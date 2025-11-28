#Set-StrictMode -Version 3.0

######################################################
##############   CONFIGURATIONS   ###################
######################################################

$SkillableEnvironment = $false
$ScriptVersion = "16.0.0"
$EnvironmentName = "" # Globally unique! Set your environment name here

if( $EnvironmentName -eq "" ) {
    $EnvironmentName = "lab" + (Get-Date -Format "yyMMddHHmmss")
}


######################################################
##############   INFRASTRUCTURE FUNCTIONS   #########
######################################################

function Import-AzureModules {
    Write-LogToBlob "Importing Azure PowerShell modules"
    
    # Ensure we're using Az modules and remove any AzureRM conflicts
    Import-Module Az.Accounts, Az.Resources -Force
    Get-Module -Name AzureRM* | Remove-Module -Force
    
    Write-LogToBlob "Azure PowerShell modules imported successfully"
}

function Get-AuthenticationHeaders {
    Write-LogToBlob "Getting access token for REST API calls"
    
    try {
        $accessTokenObject = Get-AzAccessToken -ResourceUrl "https://management.azure.com/"
        
        # Handle both SecureString and plain string token formats
        if ($accessTokenObject.Token -is [System.Security.SecureString]) {
            $token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($accessTokenObject.Token))
        }
        else {
            $token = $accessTokenObject.Token
        }

        $headers = @{
            "authorization" = "Bearer $token"
            "content-type"  = "application/json"
        }
        Write-LogToBlob "Authentication headers obtained successfully"
        
        return $headers
    }
    catch {
        Write-LogToBlob "Failed to get authentication headers: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Invoke-RestMethodWithRetry {
    param(
        [string]$Uri,
        [string]$Method = "GET",
        [hashtable]$Headers,
        [string]$Body = $null,
        [string]$ContentType = "application/json",
        [int]$MaxRetries = 1,
        [int]$DelaySeconds = 5,
        [bool]$LogDetails = $false
    )
    
    $attempt = 0
    $maxAttempts = $MaxRetries + 1
    
    while ($attempt -lt $maxAttempts) {
        $attempt++
        try {
            
            # Log detailed info only if LogDetails is true OR this is a retry attempt (attempt > 1)
            if ($LogDetails -or $attempt -gt 1) {
                Write-LogToBlob "REST API Call [$Method]: $Uri"
                if ($Body) {
                    Write-LogToBlob "REST API Call Body: $Body"
                }
            }
            
            $params = @{
                Uri = $Uri
                Method = $Method
                Headers = $Headers
                ContentType = $ContentType
            }
            
            if ($Body) {
                $params.Body = $Body
            }
            
            $response = Invoke-RestMethod @params
            
            # Log response details only if LogDetails is true OR this is a retry attempt (attempt > 1)
            if ($LogDetails -or $attempt -gt 1) {
                Write-LogToBlob "REST API Call Response: $($response | ConvertTo-Json -Depth 10)"
            }
            
            return $response
        }
        catch {
            Write-LogToBlob "-------------------------------"
            Write-LogToBlob "----API Call attempt $attempt failed. URI: $($params.Uri)" "WARN"
            Write-LogToBlob "----Request Body: $($params.Body)" "WARN"
            Write-LogToBlob "----Exception: $($_.Exception.Message)" "WARN"
            Write-LogToBlob "----Response: $response" "WARN"
            Write-LogToBlob "-------------------------------"

            if ($attempt -lt $maxAttempts) {
                Write-LogToBlob "Retrying in $DelaySeconds seconds..." "WARN"
                Start-Sleep -Seconds $DelaySeconds
            }
            else {
                Write-LogToBlob "All API retry attempts exhausted" "ERROR"
                throw
            }
        }
    }
}

function Get-AzureRegion {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$MigrateProjectName,
        [bool]$IsSkillableEnvironment
    )
    
    $defaultLocation = "swedencentral"
    Write-LogToBlob "Determining location for operations"
    
    # If Skillable environment, try to get location from MigrateProject
    if ($IsSkillableEnvironment) {
        try {
            Write-LogToBlob "Skillable environment detected - attempting to retrieve location from Migrate Project: $MigrateProjectName"
            $headers = Get-AuthenticationHeaders
            $migrateProjectUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/MigrateProjects/$MigrateProjectName" + "?api-version=2020-06-01-preview"
            
            $response = Invoke-RestMethodWithRetry -Uri $migrateProjectUri -Method GET -Headers $headers
            
            if ($response -and $response.location) {
                Write-LogToBlob "Using Migrate Project location: $($response.location)"
                return $response.location
            } else {
                Write-LogToBlob "Migrate Project location not available, using default location: $defaultLocation" -Level "WARN"
                return $defaultLocation
            }
        } catch {
            Write-LogToBlob "Could not retrieve Migrate Project location: $($_.Exception.Message). Using default location: $defaultLocation" -Level "WARN"
            return $defaultLocation
        }
    } else {
        # Non-Skillable environment: use default location (MigrateProject doesn't exist yet)
        Write-LogToBlob "Non-Skillable environment - using default location: $defaultLocation"
        return $defaultLocation
    }
}

function New-AzureEnvironment {
    param(
        [string]$EnvironmentName,
        [string]$ResourceGroupName,
        [string]$Location
    )
    
    Write-LogToBlob "Creating Azure environment: $EnvironmentName"
    
    try {
        Write-LogToBlob "Environment location: $Location"
        
        $templateFile = '.\templates\lab197959-template2 (v6).json'
        
        Write-LogToBlob "Creating resource group: $ResourceGroupName"
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force
        
        Write-LogToBlob "Deploying ARM template..."
        New-AzResourceGroupDeployment `
            -Name $EnvironmentName `
            -ResourceGroupName $ResourceGroupName `
            -TemplateFile $templateFile `
            -prefix $EnvironmentName `
            -Verbose
        
        Write-LogToBlob "Azure environment created successfully"
    }
    catch {
        Write-LogToBlob "Failed to create Azure environment: $($_.Exception.Message)" "ERROR"
        throw
    }
}

######################################################
##############   LOGGING FUNCTIONS   ################
######################################################

# Script-level variables to track logging state and buffer
$script:LoggingInitialized = $false
$script:LogBuffer = [System.Text.StringBuilder]::new()
$script:StorageContext = $null

function Write-LogToBlob {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # Write to console
    Write-Host $logEntry
    
    if ($SkillableEnvironment -eq $false) {
        return
    }

    # Add to memory buffer and immediately write to blob
    try {
        # Add log entry to buffer
        $null = $script:LogBuffer.AppendLine($logEntry)
        
        # Immediately write entire buffer to blob (overwrite)
        if($SkillableEnvironment) {
            Write-BufferToBlob
        } else {
            Write-Host "Skillable environment disabled, skipping blob logging initialization" -ForegroundColor Yellow
        }
        
    }
    catch {
        Write-Host "Failed to write log to blob: $($_.Exception.Message)" -ForegroundColor Red
        # Fallback to local file if blob fails
        $localLogFile = ".\script-execution.log"
        Add-Content -Path $localLogFile -Value $logEntry
    }
}

function Write-BufferToBlob {
    # Logging configuration constants
    $STORAGE_SAS_TOKEN = "?sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2026-01-30T22:09:19Z&st=2025-11-05T13:54:19Z&spr=https&sig=mBoL3bVHPGSniTeFzXZ5QdItTxaFYOrhXIOzzM2jvF0%3D"
    $STORAGE_ACCOUNT_NAME = "azmdeploymentlogs"
    $CONTAINER_NAME = "logs"
    $LOG_BLOB_NAME = "$environmentName.lab.txt"
    
    # Auto-initialize logging if not already done
    if (-not $script:LoggingInitialized) {
        try {
            # Initialize script-level storage context
            $script:StorageContext = New-AzStorageContext -StorageAccountName $STORAGE_ACCOUNT_NAME -SasToken $STORAGE_SAS_TOKEN
            
            # Initialize the log buffer with header
            $initialLog = "=== Script [$ScriptVersion] execution started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===`nEnvironment: $environmentName`n"
            $null = $script:LogBuffer.AppendLine($initialLog)
            
            Write-Host "Initialized log blob: $LOG_BLOB_NAME" -ForegroundColor Green
            $script:LoggingInitialized = $true
            
        }
        catch {
            Write-Host "Failed to initialize log blob: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Check if storage account and container exist" -ForegroundColor Red
            Write-Host "Also verify SAS token permissions and expiration" -ForegroundColor Red
            
            # Fallback to local file
            $localLogFile = ".\script-execution.log"
            $initialLog = "=== Script execution started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===`nEnvironment: $environmentName`n"
            Set-Content -Path $localLogFile -Value $initialLog -NoNewline
            Write-Host "Created local log file as fallback: $localLogFile" -ForegroundColor Yellow
            $script:LoggingInitialized = $true
        }
    }
    
    # Write the entire buffer content to blob, avoiding read operations
    try {
        if ($script:StorageContext -and $script:LogBuffer.Length -gt 0) {
            # Create temp file with buffer content
            $tempFile = "$env:TEMP\$([System.Guid]::NewGuid()).txt"
            Set-Content -Path $tempFile -Value $script:LogBuffer.ToString() -NoNewline
            
            # Overwrite blob with complete buffer content
            Set-AzStorageBlobContent -File $tempFile -Blob $LOG_BLOB_NAME -Container $CONTAINER_NAME -Context $script:StorageContext -Force | Out-Null
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Host "Failed to write buffer to blob: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

######################################################
##############   MIGRATE TOOL FUNCTIONS   ###########
######################################################

function Wait-AzureMigrateResources {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$MigrateProjectName,
        [string]$AssessmentProjectName,
        [string]$VMwareSiteName,
        [string]$MasterSiteName,
        [string]$WebAppSiteName,
        [string]$SqlSiteName,
        [int]$MaxWaitTimeMinutes = 15
    )
    
    Write-LogToBlob "Waiting for all Azure Migrate resources to be ready..."
    Write-LogToBlob "These resources should be created by the Skillable ARM template"
    
    $Headers = Get-AuthenticationHeaders
    $startTime = Get-Date
    $timeout = $startTime.AddMinutes($MaxWaitTimeMinutes)
    $checkCount = 0
    
    # Define all resource endpoints to check
    $resourceChecks = @(
        @{
            Name = "Migrate Project"
            Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/MigrateProjects/$MigrateProjectName" + "?api-version=2020-06-01-preview"
            Required = $true
        },
        @{
            Name = "Assessment Project"
            Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName" + "?api-version=2018-06-30-preview"
            Required = $true
        },
        @{
            Name = "VMware Site"
            Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/VMwareSites/$VMwareSiteName" + "?api-version=2024-12-01-preview"
            Required = $true
        },
        @{
            Name = "Master Site"
            Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName" + "?api-version=2024-12-01-preview"
            Required = $true
        },
        @{
            Name = "WebApp Site"
            Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/WebAppSites/$WebAppSiteName" + "?api-version=2024-12-01-preview"
            Required = $false
        },
        @{
            Name = "SQL Site"
            Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/SqlSites/$SqlSiteName" + "?api-version=2024-12-01-preview"
            Required = $false
        }
    )
    
    Write-LogToBlob "Will check $($resourceChecks.Count) resources and wait up to $MaxWaitTimeMinutes minutes"
    
    while ((Get-Date) -lt $timeout) {
        $checkCount++
        # Progressive wait intervals
        $waitSeconds = if ($checkCount -le 3) { 15 } elseif ($checkCount -le 6) { 30 } else { 45 }
        
        Write-LogToBlob "=== Resource Check #$checkCount ==="
        
        $allResourcesReady = $true
        $readyResources = @()
        $notReadyResources = @()
        
        foreach ($resource in $resourceChecks) {
            try {
                Write-LogToBlob "Checking $($resource.Name)..."
                $response = Invoke-RestMethodWithRetry -Uri $resource.Uri -Method GET -Headers $Headers
                
                if ($response) {
                    # Check provisioning state if it exists
                    $provisioningState = if ($response.properties.provisioningState) { $response.properties.provisioningState } else { "Available" }
                    
                    if ($provisioningState -eq "Succeeded" -or $provisioningState -eq "Created" -or $provisioningState -eq "Available") {
                        Write-LogToBlob "$($resource.Name): Ready (State: $provisioningState)"
                        $readyResources += $resource.Name
                    }
                    elseif ($provisioningState -eq "Failed") {
                        if ($resource.Required) {
                            Write-LogToBlob "$($resource.Name): Provisioning failed!" "ERROR"
                            throw "$($resource.Name) provisioning failed"
                        }
                        else {
                            Write-LogToBlob "$($resource.Name): Provisioning failed (optional resource)" "WARN"
                            $readyResources += $resource.Name + " (Failed-Optional)"
                        }
                    }
                    else {
                        Write-LogToBlob "$($resource.Name): Still provisioning (State: $provisioningState)"
                        $notReadyResources += $resource.Name
                        if ($resource.Required) {
                            $allResourcesReady = $false
                        }
                    }
                }
                else {
                    Write-LogToBlob "$($resource.Name): Response received but no data"
                    $notReadyResources += $resource.Name
                    if ($resource.Required) {
                        $allResourcesReady = $false
                    }
                }
            }
            catch {
                $errorMessage = $_.Exception.Message
                if ($errorMessage -like "*404*" -or $errorMessage -like "*Not Found*") {
                    Write-LogToBlob "$($resource.Name): Not found yet"
                    $notReadyResources += $resource.Name
                    if ($resource.Required) {
                        $allResourcesReady = $false
                    }
                }
                else {
                    Write-LogToBlob "$($resource.Name): Error - $errorMessage" "WARN"
                    if ($resource.Required) {
                        $notReadyResources += $resource.Name
                        $allResourcesReady = $false
                    }
                }
            }
        }
        
        # Summary of current status
        Write-LogToBlob "--- Status Summary ---"
        Write-LogToBlob "Ready: $($readyResources.Count)/$($resourceChecks.Count) - $($readyResources -join ', ')"
        if ($notReadyResources.Count -gt 0) {
            Write-LogToBlob "Not Ready: $($notReadyResources -join ', ')"
        }
        
        if ($allResourcesReady) {
            $elapsedMinutes = [math]::Round(((Get-Date) - $startTime).TotalMinutes, 1)
            Write-LogToBlob "All required Azure Migrate resources are ready! (Total time: $elapsedMinutes minutes)"
            return $true
        }
        
        Write-LogToBlob "Waiting $waitSeconds seconds before next check..."
        Start-Sleep -Seconds $waitSeconds
    }
    
    $elapsedMinutes = [math]::Round(((Get-Date) - $startTime).TotalMinutes, 1)
    Write-LogToBlob "Timeout waiting for Azure Migrate resources after $elapsedMinutes minutes ($checkCount checks)" "ERROR"
    Write-LogToBlob "The Skillable ARM template may still be deploying or there may be an issue with the deployment" "ERROR"
    Write-LogToBlob "Not ready resources: $($notReadyResources -join ', ')" "ERROR"
    throw "Timeout waiting for Azure Migrate resources to be ready after $MaxWaitTimeMinutes minutes"
}

function Register-MigrateTools {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$MigrateProjectName
    )
    
    Write-LogToBlob "Registering Azure Migrate tools"
    
    try {
        $Headers = Get-AuthenticationHeaders
        $registerToolApi = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/MigrateProjects/$MigrateProjectName/registerTool?api-version=2020-06-01-preview"
        
        Write-LogToBlob "Registering Server Discovery tool"
        Write-LogToBlob "URI: $registerToolApi"
        Invoke-RestMethodWithRetry -Uri $registerToolApi `
            -Method POST `
            -Headers $Headers `
            -Body '{"tool": "ServerDiscovery"}' | Out-Null
        Write-LogToBlob "Server Discovery tool registered successfully"

        Write-LogToBlob "Registering Server Assessment tool"
        Invoke-RestMethodWithRetry -Uri $registerToolApi `
            -Method POST `
            -Headers $Headers `
            -Body '{"tool": "ServerAssessment"}' | Out-Null
        Write-LogToBlob "Server Assessment tool registered successfully"
    }
    catch {
        Write-LogToBlob "Failed to register Migrate tools: $($_.Exception.Message)" "ERROR"
        throw
    }
}

######################################################
##############   ARTIFACT FUNCTIONS   ###############
######################################################

function Get-DiscoveryArtifacts {
    Write-LogToBlob "Downloading discovery artifacts"
    
    try {
        $remoteZipFilePath = "https://github.com/crgarcia12/migrate-modernize-lab/raw/refs/heads/main/lab-material/Azure-Migrate-Discovery.zip"
        $localZipFilePath = Join-Path (Get-Location) "importArtifacts.zip"
        
        Write-LogToBlob "Downloading artifacts from: $remoteZipFilePath"
        Invoke-WebRequest $remoteZipFilePath -OutFile $localZipFilePath
        Write-LogToBlob "Downloaded artifacts to: $localZipFilePath"
        
        return $localZipFilePath
    }
    catch {
        Write-LogToBlob "Failed to download discovery artifacts: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Start-ArtifactImport {
    param(
        [string]$LocalZipFilePath,
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$MasterSiteName
    )
    
    Write-LogToBlob "Starting artifact import process"
    
    try {
        $Headers = Get-AuthenticationHeaders
        $importUriUrl = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/masterSites/$MasterSiteName/Import?api-version=2024-12-01-preview"
        Write-LogToBlob "Import URI: $importUriUrl"
        
        $importResponse = Invoke-RestMethodWithRetry -Uri $importUriUrl -Method POST -Headers $Headers
        $blobUri = $importResponse.uri
        $jobArmId = $importResponse.jobArmId.Trim()

        Write-LogToBlob "Blob URI: $blobUri"
        Write-LogToBlob "Job ARM ID: $jobArmId"

        Write-LogToBlob "Uploading ZIP to blob..."
        $fileBytes = [System.IO.File]::ReadAllBytes($LocalZipFilePath)
        $uploadBlobHeaders = @{
            "x-ms-blob-type" = "BlockBlob"
            "x-ms-version"   = "2020-04-08"
        }
        Invoke-RestMethod -Uri $blobUri -Method PUT -Headers $uploadBlobHeaders -Body $fileBytes -ContentType "application/octet-stream"
        Write-LogToBlob "Successfully uploaded ZIP to blob"
        
        return $jobArmId
    }
    catch {
        Write-LogToBlob "Failed to start artifact import: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Wait-ImportJobCompletion {
    param(
        [string]$JobArmId
    )
    
    Write-LogToBlob "Waiting for import job completion"
    
    $JobArmId = $JobArmId.Trim()

    try {
        $Headers = Get-AuthenticationHeaders
        $apiVersionOffAzure = "2024-12-01-preview"
        $jobUrl = "https://management.azure.com$($JobArmId)?api-version=$apiVersionOffAzure"
        $waitTimeSeconds = 20
        $maxAttempts = 50 * (60 / $waitTimeSeconds)  # 50 minutes timeout
        $attempt = 0
        $jobCompleted = $false
     
        do {
            # Refresh token every 5 attempts (approximately every 1-3 minutes)
            if ($attempt % 5 -eq 0) {
                $Headers = Get-AuthenticationHeaders
            }
            
            $jobStatus = Invoke-RestMethodWithRetry -Uri $jobUrl -Method GET -Headers $Headers
            $jobResult = $jobStatus.properties.jobResult
            Write-LogToBlob "Attempt $($attempt + 1): Job status - $jobResult"

            if ($jobResult -eq "Completed") {
                $jobCompleted = $true
                break
            }
            elseif ($jobResult -eq "Failed") {
                Write-LogToBlob "====  Import job failed === " -Level "ERROR"
                Write-LogToBlob ($jobResult | ConvertTo-Json -Depth 10) -Level "ERROR"
                Write-LogToBlob "====  End Import job failed === " -Level "ERROR"
                throw "Import job failed."
            }
     
            Start-Sleep -Seconds $waitTimeSeconds
            $attempt++
        } while ($attempt -lt $maxAttempts)
     
        if (-not $jobCompleted) {
            Write-LogToBlob "Timed out waiting for import job to complete" "ERROR"
            throw "Timed out waiting for import job to complete."
        }
        else {
            Write-LogToBlob "Import job completed successfully. Machines imported."
        }
    }
    catch {
        Write-LogToBlob "Failed while waiting for import job completion: $($_.Exception.Message)" "ERROR"
        throw
    }
}

######################################################
##############   SITE AND COLLECTOR FUNCTIONS   #####
######################################################

function Get-WebAppSiteDetails {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$MasterSiteName,
        [string]$WebAppSiteName
    )
    
    Write-LogToBlob "Getting WebApp Site details"
    
    try {
        $Headers = Get-AuthenticationHeaders
        $webAppSiteUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/WebAppSites/${WebAppSiteName}?api-version=2024-12-01-preview"
        Write-LogToBlob "WebApp Site URI: $webAppSiteUri"

        $webAppSiteResponse = Invoke-RestMethodWithRetry -Uri $webAppSiteUri -Method GET -Headers $Headers
        $webAppSiteId = $webAppSiteResponse.id
        
        # Extract agent ID from siteAppliancePropertiesCollection
        $webAppAgentId = $null
        if ($webAppSiteResponse.properties.siteAppliancePropertiesCollection -and $webAppSiteResponse.properties.siteAppliancePropertiesCollection.Count -gt 0) {
            $webAppAgentId = $webAppSiteResponse.properties.siteAppliancePropertiesCollection[0].agentDetails.id
            Write-LogToBlob "WebApp Agent ID: $webAppAgentId"
        } else {
            Write-LogToBlob "No appliance properties found in WebApp site" "WARN"
        }
        
        Write-LogToBlob "WebApp Site retrieved successfully"
        
        return @{
            SiteId = $webAppSiteId
            AgentId = $webAppAgentId
        }
    }
    catch {
        Write-LogToBlob "Failed to get WebApp Site details: $($_.Exception.Message)" "WARN"
        return @{
            SiteId = $null
            AgentId = $null
        }
    }
}

function Get-SqlSiteDetails {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$MasterSiteName,
        [string]$SqlSiteName
    )
    
    Write-LogToBlob "Getting SQL Site details"
    
    try {
        $Headers = Get-AuthenticationHeaders
        $sqlSiteUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/SqlSites/${SqlSiteName}?api-version=2024-12-01-preview"
        Write-LogToBlob "SQL Site URI: $sqlSiteUri"

        $sqlSiteResponse = Invoke-RestMethodWithRetry -Uri $sqlSiteUri -Method GET -Headers $Headers
        $sqlSiteId = $sqlSiteResponse.id
        
        # Extract agent ID from siteAppliancePropertiesCollection
        $sqlAgentId = $null
        if ($sqlSiteResponse.properties.siteAppliancePropertiesCollection -and $sqlSiteResponse.properties.siteAppliancePropertiesCollection.Count -gt 0) {
            $sqlAgentId = $sqlSiteResponse.properties.siteAppliancePropertiesCollection[0].agentDetails.id
            Write-LogToBlob "SQL Agent ID: $sqlAgentId"
        } else {
            Write-LogToBlob "No appliance properties found in SQL site" "WARN"
        }
        
        Write-LogToBlob "SQL Site retrieved successfully"
        
        return @{
            SiteId = $sqlSiteId
            AgentId = $sqlAgentId
        }
    }
    catch {
        Write-LogToBlob "Failed to get SQL Site details: $($_.Exception.Message)" "WARN"
        return @{
            SiteId = $null
            AgentId = $null
        }
    }
}

function Get-VMwareCollectorAgentId {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$VMwareSiteName
    )
    
    Write-LogToBlob "Getting VMware Collector Agent ID"
    
    try {
        $Headers = Get-AuthenticationHeaders
        $vmwareSiteUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/VMwareSites/${VMwareSiteName}?api-version=2024-12-01-preview"
        $vmwareSiteResponse = Invoke-RestMethodWithRetry -Uri $vmwareSiteUri -Method GET -Headers $Headers
        
        Write-LogToBlob "VMware Site Response received"
        Write-LogToBlob "$($vmwareSiteResponse | ConvertTo-Json -Depth 10)"
        
        $agentId = $vmwareSiteResponse.properties.agentDetails.id
        Write-LogToBlob "Agent ID extracted: $agentId"
        
        return $agentId
    }
    catch {
        Write-LogToBlob "Failed to get VMware Collector Agent ID: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Invoke-VMwareCollectorSync {
    param(
        [string]$AgentId,
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$AssessmentProjectName,
        [string]$EnvironmentName,
        [string]$VMwareSiteName
    )
    
    Write-LogToBlob "Synchronizing VMware Collector"
    
    try {
        $Headers = Get-AuthenticationHeaders
        
        # Define names used only in this function
        $vmwareCollectorName = "${EnvironmentName}vmwaresitevmwarecollector"
        
        $vmwareCollectorUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/vmwarecollectors/${vmwareCollectorName}?api-version=2018-06-30-preview"
        Write-LogToBlob "VMware Collector URI: $vmwareCollectorUri"
        
        $vmwareCollectorBody = @{
            "id"         = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/vmwarecollectors/$vmwareCollectorName"
            "name"       = "$vmwareCollectorName"
            "type"       = "Microsoft.Migrate/assessmentprojects/vmwarecollectors"
            "properties" = @{
                "agentProperties" = @{
                    "id"               = "$AgentId"
                    "lastHeartbeatUtc" = "2025-04-24T09:48:04.3893222Z"
                    "spnDetails"       = @{
                        "authority"     = "authority"
                        "applicationId" = "appId"
                        "audience"      = "audience"
                        "objectId"      = "objectid"
                        "tenantId"      = "tenantid"
                    }
                }
                "discoverySiteId" = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/VMwareSites/$VMwareSiteName"
            }
        } | ConvertTo-Json -Depth 10
        
        Write-LogToBlob "VMware Collector Body:"
        Write-LogToBlob "$vmwareCollectorBody"

        $response = Invoke-RestMethodWithRetry -Uri $vmwareCollectorUri `
            -Method PUT `
            -Headers $Headers `
            -Body $vmwareCollectorBody

        Write-LogToBlob "VMware Collector sync response:"
        Write-LogToBlob "$($response | ConvertTo-Json -Depth 10)"
        
        Write-LogToBlob "VMware Collector synchronized successfully"
    }
    catch {
        Write-LogToBlob "Failed to synchronize VMware Collector: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function New-WebAppCollector {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$AssessmentProjectName,
        [string]$EnvironmentName,
        [string]$WebAppSiteId,
        [string]$WebAppAgentId
    )
    
    Write-LogToBlob "Creating WebApp Collector"
    
    try {
        if (-not $WebAppAgentId -or -not $WebAppSiteId) {
            Write-LogToBlob "Skipping WebApp Collector creation - missing WebApp agent ID or site ID" "WARN"
            return $false
        }

        $Headers = Get-AuthenticationHeaders

        # Define names used only in this function
        $webAppCollectorName = "${EnvironmentName}webappsitecollector"
        
        $webAppCollectorUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/webappcollectors/${webAppCollectorName}?api-version=2025-09-09-preview"
        Write-LogToBlob "WebApp Collector URI: $webAppCollectorUri"
        
        $webAppCollectorBody = @{
            "id" = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/webappcollectors/$webAppCollectorName"
            "name" = "$webAppCollectorName"
            "type" = "Microsoft.Migrate/assessmentprojects/webappcollectors"
            "properties" = @{
                "agentProperties" = @{
                    "id" = $WebAppAgentId
                    "version" = $null
                    "lastHeartbeatUtc" = $null
                    "spnDetails" = @{
                        "authority" = "authority"
                        "applicationId" = "appId"
                        "audience" = "audience"
                        "objectId" = "objectid"
                        "tenantId" = "tenantid"
                    }
                }
                "discoverySiteId" = $WebAppSiteId
            }
        } | ConvertTo-Json -Depth 10
        
        Invoke-RestMethodWithRetry -Uri $webAppCollectorUri `
            -Method PUT `
            -Headers $Headers `
            -Body $webAppCollectorBody | Out-Null
            
        Write-LogToBlob "WebApp Collector created successfully"
        return $true
    }
    catch {
        Write-LogToBlob "Failed to create WebApp Collector: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function New-SqlCollector {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$AssessmentProjectName,
        [string]$EnvironmentName,
        [string]$SqlSiteId,
        [string]$SqlAgentId
    )
    
    Write-LogToBlob "Creating SQL Collector"
    
    try {
        if (-not $SqlAgentId -or -not $SqlSiteId) {
            Write-LogToBlob "Skipping SQL Collector creation - missing SQL agent ID or site ID" "WARN"
            return $false
        }

        $Headers = Get-AuthenticationHeaders

        # Define names used only in this function
        $sqlCollectorName = "${EnvironmentName}sqlsitescollector"
        
        $sqlCollectorUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/sqlcollectors/${sqlCollectorName}?api-version=2025-09-09-preview"
        Write-LogToBlob "SQL Collector URI: $sqlCollectorUri"
        
        $sqlCollectorBody = @{
            "id" = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/sqlcollectors/$sqlCollectorName"
            "name" = "$sqlCollectorName"
            "type" = "Microsoft.Migrate/assessmentprojects/sqlcollectors"
            "properties" = @{
                "agentProperties" = @{
                    "id" = $SqlAgentId
                    "version" = $null
                    "lastHeartbeatUtc" = $null
                    "spnDetails" = @{
                        "authority" = "authority"
                        "applicationId" = "appId"
                        "audience" = "audience"
                        "objectId" = "objectid"
                        "tenantId" = "tenantid"
                    }
                }
                "discoverySiteId" = $SqlSiteId
            }
        } | ConvertTo-Json -Depth 10
        
        Invoke-RestMethodWithRetry -Uri $sqlCollectorUri `
            -Method PUT `
            -Headers $Headers `
            -Body $sqlCollectorBody | Out-Null
            
        Write-LogToBlob "SQL Collector created successfully"
        return $true
    }
    catch {
        Write-LogToBlob "Failed to create SQL Collector: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

######################################################
##############   ASSESSMENT FUNCTIONS   #############
######################################################

function New-VMAssessment {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$AssessmentProjectName,
        [string]$Location,
        [string]$VMwareSiteName
    )
    
    Write-LogToBlob "Creating migration assessment"
    
    try {
        $assessmentName = "vm-assessment"
        $headers = Get-AuthenticationHeaders
        $apiVersion = "2025-09-09-preview"
        $assessmentBody = @{
            "type" = "Microsoft.Migrate/assessmentprojects/assessments"
            "apiVersion" = $apiVersion
            "name" = "$AssessmentProjectName/$assessmentName"
            "location" = $Location
            "tags" = @{}
            "kind" = "Migrate"
            "properties" = @{
                "settings" = @{
                    "performanceData" = @{
                        "timeRange" = "Day"
                        "percentile" = "Percentile95"
                    }
                    "scalingFactor" = 1
                    "azureSecurityOfferingType" = "MDC"
                    "azureHybridUseBenefit" = "Yes"
                    "linuxAzureHybridUseBenefit" = "Yes"
                    "savingsSettings" = @{
                        "savingsOptions" = "RI3Year"
                    }
                    "billingSettings" = @{
                        "licensingProgram" = "Retail"
                        "subscriptionId" = "$SubscriptionId"
                    }
                    "azureDiskTypes" = @()
                    "azureLocation" = $Location
                    "azureVmFamilies" = @()
                    "environmentType" = "Production"
                    "currency" = "USD"
                    "discountPercentage" = 0
                    "sizingCriterion" = "PerformanceBased"
                    "azurePricingTier" = "Standard"
                    "azureStorageRedundancy" = "LocallyRedundant"
                    "vmUptime" = @{
                        "daysPerMonth" = "31"
                        "hoursPerDay" = "24"
                    }
                }
                "details" = @{}
                "scope" = @{
                    "azureResourceGraphQuery" = @"
migrateresources
| where id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/vmwareSites/$VMwareSiteName"
"@
                    "scopeType" = "AzureResourceGraphQuery"
                }
            }
        } | ConvertTo-Json -Depth 10

        $assessmentUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentProjects/$AssessmentProjectName/assessments/${assessmentName}?api-version=$apiVersion"
        
        $response = Invoke-RestMethodWithRetry `
            -Uri $assessmentUri `
            -Method PUT `
            -Headers $headers `
            -Body $assessmentBody

        Write-LogToBlob "Assessment created successfully"

        # Extract the assessment ID from the response
        $assessmentId = $response.id
        Write-LogToBlob "VM Assessment ID: $assessmentId"

        return $assessmentId
    }
    catch {
        Write-LogToBlob "Failed to create migration assessment: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function New-SqlAssessment {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$AssessmentProjectName,
        [string]$Location,
        [string]$VMwareSiteName,
        [string]$MasterSiteName,
        [string]$WebAppSiteName,
        [string]$SqlSiteName
    )
    
    Write-LogToBlob "Creating SQL Assessment"
    
    try {
        $Headers = Get-AuthenticationHeaders
        
        $assessmentName = "sql-assessment"
        $apiVersion = "2025-09-09-preview"
        
        $assessmentBody = @{
            "type" = "Microsoft.Migrate/assessmentprojects/assessments"
            "apiVersion" = "$apiVersion"
            "name" = "$AssessmentProjectName/$assessmentName"
            "location" = $Location
            "tags" = @{}
            "kind" = "Migrate"
            "properties" = @{
                "settings" = @{
                    "performanceData" = @{
                        "timeRange" = "Day"
                        "percentile" = "Percentile95"
                    }
                    "scalingFactor" = 1
                    "azureSecurityOfferingType" = "MDC"
                    "osLicense" = "Yes"
                    "azureLocation" = $Location
                    "preferredTargets" = @("SqlMI")
                    "discountPercentage" = 0
                    "currency" = "USD"
                    "sizingCriterion" = "PerformanceBased"
                    "savingsSettings" = @{
                        "savingsOptions" = "SavingsPlan1Year"
                    }
                    "billingSettings" = @{
                        "licensingProgram" = "Retail"
                        "subscriptionId" = "$SubscriptionId"
                    }
                    "sqlServerLicense" = "Yes"
                    "azureSqlVmSettings" = @{
                        "instanceSeries" = @(
                            "Ddsv4_series",
                            "Ddv4_series",
                            "Edsv4_series",
                            "Edv4_series"
                        )
                    }
                    "entityUptime" = @{
                        "daysPerMonth" = 31
                        "hoursPerDay" = 24
                    }
                    "azureSqlManagedInstanceSettings" = @{
                        "azureSqlInstanceType" = "SingleInstance"
                        "azureSqlServiceTier" = "SqlServiceTier_Automatic"
                    }
                    "azureSqlDatabaseSettings" = @{
                        "azureSqlComputeTier" = "Provisioned"
                        "azureSqlPurchaseModel" = "VCore"
                        "azureSqlServiceTier" = "SqlServiceTier_Automatic"
                        "azureSqlDataBaseType" = "SingleDatabase"
                    }
                    "environmentType" = "Production"
                    "enableHadrAssessment" = $true
                    "disasterRecoveryLocation" = $Location
                    "multiSubnetIntent" = "DisasterRecovery"
                    "isInternetAccessAvailable" = $true
                    "asyncCommitModeIntent" = "DisasterRecovery"
                }
                "details" = @{}
                "scope" = @{
                    "azureResourceGraphQuery" = @"
migrateresources
| where id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/vmwareSites/$VMwareSiteName" or
    id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/WebAppSites/$WebAppSiteName" or
    id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/SqlSites/$SqlSiteName"
"@
                    "scopeType" = "AzureResourceGraphQuery"
                }
            }
        } | ConvertTo-Json -Depth 10

        $assessmentUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/sqlassessments/${assessmentName}?api-version=$apiVersion"
        
        $response = Invoke-RestMethodWithRetry `
            -Uri $assessmentUri `
            -Method PUT `
            -Headers $Headers `
            -Body $assessmentBody

        Write-LogToBlob "SQL Assessment created successfully"
        
        # Extract the assessment ID from the response
        $assessmentId = $response.id
        Write-LogToBlob "SQL Assessment ID: $assessmentId"
        
        return $assessmentId
    }
    catch {
        Write-LogToBlob "Failed to create SQL assessment: $($_.Exception.Message)" "ERROR"
        throw
    }
}


function New-GlobalAssessment {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$AssessmentProjectName,
        [string]$Location,
        [string]$VmAssessmentId,
        [string]$SqlAssessmentId
    )
    
    Write-LogToBlob "Creating Global Assessment"
    
    try {
        $Headers = Get-AuthenticationHeaders
        
        $heteroAssessmentName = "full-assessment"
        $heteroApiVersion = "2025-09-09-preview"
        
        $heteroAssessmentBody = @{
            "kind" = "Migrate"
            "location" = $Location
            "tags" = @{}
            "properties" = @{
                "assessmentArmIds" = @(
                    $VmAssessmentId,
                    $SqlAssessmentId
                )
            }
        } | ConvertTo-Json -Depth 10

        $heteroAssessmentUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/heterogeneousAssessments/${heteroAssessmentName}?api-version=$heteroApiVersion"
        
        Invoke-RestMethodWithRetry -Uri $heteroAssessmentUri `
            -Method PUT `
            -Headers $Headers `
            -Body $heteroAssessmentBody `
            -LogDetails $true | Out-Null

        Write-LogToBlob "Global Assessment created successfully"
        
        return $heteroAssessmentName
    }
    catch {
        Write-LogToBlob "Failed to create Global Assessment: $($_.Exception.Message)" "ERROR"
        throw
    }
}

######################################################
##############   BUSINESS CASE FUNCTIONS   ##########
######################################################

function New-BusinessCaseOptimizeForPaas {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$AssessmentProjectName,
        [string]$Location,
        [string]$VMwareSiteName,
        [string]$MasterSiteName,
        [string]$WebAppSiteName,
        [string]$SqlSiteName
    )
    
    Write-LogToBlob "Creating OptimizeForPaas Business Case"
    
    try {
        $Headers = Get-AuthenticationHeaders
        $businessCaseName = "businesscase-for-paas"
        $businessCaseApiVersion = "2025-09-09-preview"
        
        $businessCaseBody = @{
            "type" = "Microsoft.Migrate/assessmentprojects/businesscases"
            "apiVersion" = "$businessCaseApiVersion"
            "name" = "$AssessmentProjectName/$businessCaseName"
            "location" = $Location
            "kind" = "Migrate"
            "properties" = @{
                "businessCaseScope" = @{
                    "scopeType" = "Datacenter"
                    "azureResourceGraphQuery" = @"
migrateresources
| where id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/vmwareSites/$VMwareSiteName" or
    id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/WebAppSites/$WebAppSiteName" or
    id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/SqlSites/$SqlSiteName"
"@
                }
                "settings" = @{
                    "commonSettings" = @{
                        "targetLocation" = $Location
                        "infrastructureGrowthRate" = 0
                        "currency" = "USD"
                        "workloadDiscoverySource" = "Appliance"
                        "businessCaseType" = "OptimizeForPaas"
                    }
                    "azureSettings" = @{
                        "savingsOption" = "RI3Year"
                    }
                }
                "details" = @{}
            }
        } | ConvertTo-Json -Depth 10

        $businessCaseUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/businesscases/${businessCaseName}?api-version=$businessCaseApiVersion"
        
        Invoke-RestMethodWithRetry -Uri $businessCaseUri `
            -Method PUT `
            -Headers $Headers `
            -Body $businessCaseBody `
            -LogDetails $true | Out-Null

        Write-LogToBlob "OptimizeForPaas Business Case created successfully"
        
        return $businessCaseName
    }
    catch {
        Write-LogToBlob "Failed to create OptimizeForPaas Business Case: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function New-BusinessCaseIaasOnly {
    param(
        [string]$SubscriptionId,
        [string]$ResourceGroupName,
        [string]$AssessmentProjectName,
        [string]$Location,
        [string]$VMwareSiteName,
        [string]$MasterSiteName,
        [string]$WebAppSiteName,
        [string]$SqlSiteName
    )
    
    Write-LogToBlob "Creating IaaSOnly Business Case"
    
    try {
        $Headers = Get-AuthenticationHeaders
        $businessCaseName = "businesscase-for-iaas"
        $businessCaseApiVersion = "2025-09-09-preview"
        
        $businessCaseBody = @{
            "type" = "Microsoft.Migrate/assessmentprojects/businesscases"
            "apiVersion" = "$businessCaseApiVersion"
            "name" = "$AssessmentProjectName/$businessCaseName"
            "location" = $Location
            "kind" = "Migrate"
            "properties" = @{
                "businessCaseScope" = @{
                    "scopeType" = "Datacenter"
                    "azureResourceGraphQuery" = @"
migrateresources
| where id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/vmwareSites/$VMwareSiteName" or
    id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/WebAppSites/$WebAppSiteName" or
    id contains "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OffAzure/MasterSites/$MasterSiteName/SqlSites/$SqlSiteName"
"@
                }
                "settings" = @{
                    "commonSettings" = @{
                        "targetLocation" = $Location
                        "infrastructureGrowthRate" = 0
                        "currency" = "USD"
                        "workloadDiscoverySource" = "Appliance"
                        "businessCaseType" = "IaaSOnly"
                    }
                    "azureSettings" = @{
                        "savingsOption" = "RI3Year"
                    }
                }
                "details" = @{}
            }
        } | ConvertTo-Json -Depth 10

        $businessCaseUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/assessmentprojects/$AssessmentProjectName/businesscases/${businessCaseName}?api-version=$businessCaseApiVersion"
        
        Invoke-RestMethodWithRetry -Uri $businessCaseUri `
            -Method PUT `
            -Headers $Headers `
            -Body $businessCaseBody `
            -LogDetails $true | Out-Null

        Write-LogToBlob "IaaSOnly Business Case created successfully"
        
        return $businessCaseName
    }
    catch {
        Write-LogToBlob "Failed to create IaaSOnly Business Case: $($_.Exception.Message)" "ERROR"
        throw
    }
}

######################################################
##############   MAIN EXECUTION FUNCTION   ##########
######################################################

function Invoke-AzureMigrateConfiguration {
    param(
        [bool] $SkillableEnvironment,
        [string] $EnvironmentName
    )
    
    # Environment name and prefix for all azure resources
    if ($SkillableEnvironment) {
        $EnvironmentName = "<LABINSTANCEID>"
    }
    else {
        $EnvironmentName = $EnvironmentName
    }

    # Define all resource names
    $subscriptionId = (Get-AzContext).Subscription.Id
    $resourceGroupName = if ($SkillableEnvironment) { "on-prem" } else { "${EnvironmentName}-rg" }
    $migrateProjectName = "${EnvironmentName}-azm"
    $assessmentProjectName = "${EnvironmentName}asmproject"
    $vmwareSiteName = "${EnvironmentName}vmwaresite"
    $webAppSiteName = "${EnvironmentName}webappsite"
    $sqlSiteName = "${environmentName}sqlsites"
    $masterSiteName = "${EnvironmentName}mastersite"
    
    # Get the location for all operations
    $location = Get-AzureRegion -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -MigrateProjectName $migrateProjectName -IsSkillableEnvironment $SkillableEnvironment
    
    # Log all variable values
    Write-LogToBlob "===============================  VARIABLES ================================"
    Write-LogToBlob "Skillable Mode: $SkillableEnvironment" 
    Write-LogToBlob "Environment Name: $environmentName"
    Write-LogToBlob "Subscription ID: $subscriptionId"
    Write-LogToBlob "Resource Group Name: $resourceGroupName"
    Write-LogToBlob "Location: $location"
    Write-LogToBlob "Master Site Name: $masterSiteName"
    Write-LogToBlob "Migrate Project Name: $migrateProjectName"
    Write-LogToBlob "Assessment Project Name: $assessmentProjectName"
    Write-LogToBlob "VMware Site Name: $vmwareSiteName"
    Write-LogToBlob "WebApp Site Name: $webAppSiteName"
    Write-LogToBlob "SQL Site Name: $sqlSiteName"
    Write-LogToBlob "===============================  VARIABLES ================================"

    try {
        # Step 1: Initialize modules and log the start       
        Import-AzureModules

        # Step 2: Create Azure environment (skip if Skillable)
        if (-not $SkillableEnvironment) {
            New-AzureEnvironment -EnvironmentName $environmentName -ResourceGroupName $resourceGroupName -Location $location
        }
        
        # Step 3: Wait for all Azure Migrate resources to be ready (created by Skillable ARM template)
        Wait-AzureMigrateResources -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -MigrateProjectName $migrateProjectName -AssessmentProjectName $assessmentProjectName -VMwareSiteName $vmwareSiteName -MasterSiteName $masterSiteName -WebAppSiteName $webAppSiteName -SqlSiteName $sqlSiteName
        
        # Step 4: Register Azure Migrate tools
        Register-MigrateTools -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -MigrateProjectName $migrateProjectName
        
        # Step 5: Download and import discovery artifacts
        $localZipPath = Get-DiscoveryArtifacts
        $jobArmId = Start-ArtifactImport -LocalZipFilePath $localZipPath -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -MasterSiteName $masterSiteName
        Wait-ImportJobCompletion -JobArmId $jobArmId
        
        # Step 6: Get site details for WebApp and SQL
        $webAppSiteDetails = Get-WebAppSiteDetails -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -MasterSiteName $masterSiteName -WebAppSiteName $webAppSiteName
        $sqlSiteDetails = Get-SqlSiteDetails -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -MasterSiteName $masterSiteName -SqlSiteName $sqlSiteName
        
        # Step 7: Configure VMware Collector
        $agentId = Get-VMwareCollectorAgentId -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -VMwareSiteName $vmwareSiteName
        Invoke-VMwareCollectorSync -AgentId $agentId -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -AssessmentProjectName $assessmentProjectName -EnvironmentName $environmentName -VMwareSiteName $vmwareSiteName
        
        # Step 8: Create WebApp and SQL Collectors (if available)
        $webAppCollectorCreated = New-WebAppCollector -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -AssessmentProjectName $assessmentProjectName -EnvironmentName $environmentName -WebAppSiteId $webAppSiteDetails.SiteId -WebAppAgentId $webAppSiteDetails.AgentId
        $sqlCollectorCreated = New-SqlCollector -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -AssessmentProjectName $assessmentProjectName -EnvironmentName $environmentName -SqlSiteId $sqlSiteDetails.SiteId -SqlAgentId $sqlSiteDetails.AgentId
        
        # Step 9: Create assessments
        $vmAssessmentId = New-VMAssessment -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -AssessmentProjectName $assessmentProjectName -Location $location -VMwareSiteName $vmwareSiteName
        $sqlAssessmentId = New-SqlAssessment -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -AssessmentProjectName $assessmentProjectName -Location $location -VMwareSiteName $vmwareSiteName -MasterSiteName $masterSiteName -WebAppSiteName $webAppSiteName -SqlSiteName $sqlSiteName
        
        # Step 10: Create business cases
        $paasBusinessCaseName = New-BusinessCaseOptimizeForPaas -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -AssessmentProjectName $assessmentProjectName -Location $location -VMwareSiteName $vmwareSiteName -MasterSiteName $masterSiteName -WebAppSiteName $webAppSiteName -SqlSiteName $sqlSiteName
        $iaasBusinessCaseName = New-BusinessCaseIaasOnly -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -AssessmentProjectName $assessmentProjectName -Location $location -VMwareSiteName $vmwareSiteName -MasterSiteName $masterSiteName -WebAppSiteName $webAppSiteName -SqlSiteName $sqlSiteName
        
        # Step 11: Create global assessment
        $heteroAssessmentName = New-GlobalAssessment -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -AssessmentProjectName $assessmentProjectName -Location $location -VmAssessmentId $vmAssessmentId -SqlAssessmentId $sqlAssessmentId
        
        Write-LogToBlob "=== Azure Migrate Configuration Completed Successfully ==="
        Write-LogToBlob "Summary of created resources:"
        Write-LogToBlob "- VMware Collector: Synchronized"
        Write-LogToBlob "- WebApp Collector: $(if ($webAppCollectorCreated) { 'Created' } else { 'Skipped' })"
        Write-LogToBlob "- SQL Collector: $(if ($sqlCollectorCreated) { 'Created' } else { 'Skipped' })"
        Write-LogToBlob "- VM Assessment: ID: $vmAssessmentId"
        Write-LogToBlob "- SQL Assessment ID: $sqlAssessmentId"
        Write-LogToBlob "- PaaS Business Case: $paasBusinessCaseName"
        Write-LogToBlob "- IaaS Business Case: $iaasBusinessCaseName"
        Write-LogToBlob "- Global Assessment: $heteroAssessmentName"
    }
    catch {
        Write-LogToBlob "=== Azure Migrate Configuration Failed ===" "ERROR"
        Write-LogToBlob "Error: $($_.Exception.Message)" "ERROR"
        throw
    }
}

######################################################
##############   SCRIPT EXECUTION   #################
######################################################

# Execute the main function
try {
    Invoke-AzureMigrateConfiguration `
        -SkillableEnvironment $SkillableEnvironment `
        -EnvironmentName $EnvironmentName
} catch {
    Write-Host "Script execution failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
