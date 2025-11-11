# Download and Configure Azure Migrate Script
# This script downloads the configure-azm.ps1 script from GitHub and executes it
# Designed for non-interactive execution

# Configuration
$ScriptUrl = "https://github.com/crgarcia12/migrate-modernize-lab/raw/refs/heads/main/infra/configure-azm.ps1"
$TempPath = $env:TEMP
$ScriptVersion = "8.0.0"

# Script-level variable to track if logging has been initialized
$script:LoggingInitialized = $false

######################################################
##############   LOGGING FUNCTIONS   ################
######################################################

function Write-LogToBlob {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    # Blob storage configuration for logging
    $STORAGE_SAS_TOKEN = "?sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2026-01-30T22:09:19Z&st=2025-11-05T13:54:19Z&spr=https&sig=mBoL3bVHPGSniTeFzXZ5QdItTxaFYOrhXIOzzM2jvF0%3D"
    $STORAGE_ACCOUNT_NAME = "azmdeploymentlogs"
    $CONTAINER_NAME = "logs"
    $SkillableEnvironment = $true
    $environmentName = "download@lab.LabInstance.ID"
    
    # Auto-initialize logging if not already done
    if ($SkillableEnvironment -eq $true -and -not $script:LoggingInitialized) {
        Initialize-LogBlob -StorageAccountName $STORAGE_ACCOUNT_NAME -SasToken $STORAGE_SAS_TOKEN -ContainerName $CONTAINER_NAME -EnvironmentName $environmentName
    }
    
    $LOG_BLOB_NAME = "$environmentName.download.txt"
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # Write to console
    Write-Host $logEntry
    
    if ($SkillableEnvironment -eq $false) {
        return
    }

    # Write to blob using Az.Storage commands
    try {
        # Create storage context using SAS token
        $ctx = New-AzStorageContext -StorageAccountName $STORAGE_ACCOUNT_NAME -SasToken $STORAGE_SAS_TOKEN        # Get existing blob content to append
        $existingContent = ""
        try {
            Get-AzStorageBlobContent -Blob $LOG_BLOB_NAME -Container $CONTAINER_NAME -Context $ctx -Force -Destination "$env:TEMP\templog.txt" -ErrorAction Stop | Out-Null
            $existingContent = Get-Content "$env:TEMP\templog.txt" -Raw -ErrorAction SilentlyContinue
            Remove-Item "$env:TEMP\templog.txt" -Force -ErrorAction SilentlyContinue
        }
        catch {
            # Blob doesn't exist yet, that's fine
            Write-Host "Creating new log blob..." -ForegroundColor Yellow
        }
        
        # Append new log entry
        $newContent = $existingContent + $logEntry + "`n"
        
        # Write back to blob
        $tempFile = "$env:TEMP\$([System.Guid]::NewGuid()).txt"
        Set-Content -Path $tempFile -Value $newContent -NoNewline
        Set-AzStorageBlobContent -File $tempFile -Blob $LOG_BLOB_NAME -Container $CONTAINER_NAME -Context $ctx -Force | Out-Null
        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        
    }
    catch {
        Write-Host "Failed to write log to blob: $($_.Exception.Message)" -ForegroundColor Red
        # Fallback to local file if blob fails
        $localLogFile = ".\script-execution.log"
        Add-Content -Path $localLogFile -Value $logEntry
    }
}

function Initialize-LogBlob {
    param(
        [string]$StorageAccountName,
        [string]$SasToken,
        [string]$ContainerName,
        [string]$EnvironmentName
    )
    
    # Skip initialization if already done
    if ($script:LoggingInitialized) {
        return
    }
    
    $LOG_BLOB_NAME = "$EnvironmentName.log.txt"
    $SkillableEnvironment = $true
    
    if (-not $SkillableEnvironment) {
        Write-Host "Skillable environment disabled, skipping blob logging initialization" -ForegroundColor Yellow
        $script:LoggingInitialized = $true
        return
    }

    try {
        $ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SasToken
        
        $initialLog = "=== Download Script [$ScriptVersion] execution started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===`nEnvironment: $EnvironmentName`n"
        
        $tempFile = "$env:TEMP\$([System.Guid]::NewGuid()).txt"
        Set-Content -Path $tempFile -Value $initialLog -NoNewline
        
        Set-AzStorageBlobContent -File $tempFile -Blob $LOG_BLOB_NAME -Container $ContainerName -Context $ctx -Force | Out-Null
        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        
        Write-Host "Initialized log blob: $LOG_BLOB_NAME" -ForegroundColor Green
        $script:LoggingInitialized = $true
        
    }
    catch {
        Write-Host "Failed to initialize log blob: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Check if storage account '$StorageAccountName' and container '$ContainerName' exist" -ForegroundColor Red
        Write-Host "Also verify SAS token permissions and expiration" -ForegroundColor Red
        
        # Fallback to local file
        $localLogFile = ".\script-execution.log"
        $initialLog = "=== Download Script execution started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===`nEnvironment: $EnvironmentName`n"
        Set-Content -Path $localLogFile -Value $initialLog -NoNewline
        Write-Host "Created local log file as fallback: $localLogFile" -ForegroundColor Yellow
        $script:LoggingInitialized = $true
    }
}

# Set error action preference to stop on errors
$ErrorActionPreference = "Stop"
Write-LogToBlob "=== Starting download and configuration process ==="

Write-LogToBlob "Importing Az modules. Make sure ARM modules are not loaded..."
Import-Module Az.Accounts, Az.Resources -Force
Get-Module -Name AzureRM* | Remove-Module -Force

# Check current execution policy and handle automatically
$CurrentExecutionPolicy = Get-ExecutionPolicy
Write-LogToBlob "Current PowerShell execution policy: $CurrentExecutionPolicy"

try {
    # Create a temporary file path
    $TempScriptPath = Join-Path (Get-Location).Path "configure-azm.ps1"
    
    Write-LogToBlob "Downloading script from: $ScriptUrl"
    Write-LogToBlob "Temporary location: $TempScriptPath"
    Write-LogToBlob "Subscription ID: '${(Get-AzContext).Subscription.Id}'"

    # Download the script
    Invoke-WebRequest -Uri $ScriptUrl -OutFile $TempScriptPath -UseBasicParsing
    if ($TempScriptPath -and (Test-Path $TempScriptPath)) {
        Write-LogToBlob "Script downloaded successfully!"
        # Verify the file is not empty
        $FileSize = (Get-Item $TempScriptPath).Length
        if ($FileSize -gt 0) {
            Write-LogToBlob "File size: $FileSize bytes"
            # Unblock the downloaded file to remove the "downloaded from internet" flag
            Write-LogToBlob "Unblocking downloaded script..."
            try {
                Unblock-File -Path $TempScriptPath
                Write-LogToBlob "Script unblocked successfully!"
            }
            catch {
                Write-LogToBlob "Could not unblock file: $($_.Exception.Message)" "WARN"
                Write-LogToBlob "Continuing with execution..."
            }
            # Replace <LABINSTANCEID> placeholder with @lab.LabInstance.ID
            Write-LogToBlob "Processing script content to replace placeholders..."
            try {
                $ScriptContent = Get-Content -Path $TempScriptPath -Raw
                if ($ScriptContent -match "<LABINSTANCEID>") {
                    $ModifiedContent = $ScriptContent -replace "<LABINSTANCEID>", "@lab.LabInstance.ID"
                    Set-Content -Path $TempScriptPath -Value $ModifiedContent -NoNewline
                    Write-LogToBlob "Replaced <LABINSTANCEID> with @lab.LabInstance.ID"
                }
                else {
                    Write-LogToBlob "No <LABINSTANCEID> placeholder found in script."
                }
            }
            catch {
                Write-LogToBlob "Could not process script content: $($_.Exception.Message)" "WARN"
                Write-LogToBlob "Continuing with original script..."
            }
            Write-LogToBlob "Executing downloaded script..."
            # Always use PowerShell with bypass to ensure execution in non-interactive mode
            Write-LogToBlob "Using execution policy bypass to ensure script runs..."
            . $TempScriptPath

            
            # & pwsh -ExecutionPolicy Bypass -File $TempScriptPath
            Write-LogToBlob "Downloaded script execution completed!"
        }
        else {
            throw "Downloaded file is empty or corrupted."
        }
    }
    else {
        throw "Failed to download the script."
    }
}
catch {
    Write-LogToBlob "An error occurred: $($_.Exception.Message)" "ERROR"
    exit 1
}
finally {
    # Clean up the temporary file
    if (Test-Path $TempScriptPath) {
        try {
            Remove-Item $TempScriptPath -Force
            Write-LogToBlob "Temporary file cleaned up."
        }
        catch {
            Write-LogToBlob "Could not clean up temporary file: $TempScriptPath" "WARN"
        }
    }
}

Write-LogToBlob "Download and configure process completed."