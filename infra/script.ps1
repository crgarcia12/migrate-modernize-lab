$environmentName = "mig19"

$subscriptionId = (Get-AzContext).Subscription.Id
$resourceGroup = "$environmentName-rg"
$masterSiteName = "$($environmentName)mastersite"
$migrateProjectName = "${environmentName}-azm"

$apiVersionOffAzure = "2024-12-01-preview"

$remoteZipFilePath = "https://github.com/crgarcia12/migrate-modernize-lab/raw/refs/heads/main/lab-material/Azure-Migrate-Discovery.zip"
$localZipFilePath = Join-Path (Get-Location) "importArtifacts.zip"
Invoke-WebRequest $remoteZipFilePath -OutFile $localZipFilePath

# Create resource group and deploy ARM template
New-AzResourceGroup -Name "${environmentName}-rg" -Location "swedencentral"
New-AzResourceGroupDeployment `
    -Name $environmentName `
    -ResourceGroupName "${environmentName}-rg" `
    -TemplateFile '.\templates\lab197959-template2 (v6).json' `
    -prefix $environmentName `
    -Verbose

# Get access token for REST API calls
$secureToken = (Get-AzAccessToken -ResourceUrl "https://management.azure.com/").Token
$token = (New-Object PSCredential 0, $secureToken).GetNetworkCredential().Password

$headers=@{} 
$headers.Add("authorization", "Bearer $token") 
$headers.Add("content-type", "application/json") 

$registerToolApi = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/MigrateProjects/$migrateProjectName/registerTool?api-version=2020-06-01-preview"
Write-Host "Register Server Discovery"
$response = Invoke-RestMethod -Uri $registerToolApi `
    -Method POST `
    -Headers $headers `
    -ContentType 'application/json' `
    -Body '{   "tool": "ServerDiscovery" }'

Write-Host "Register Server Assessment"
$response = Invoke-RestMethod -Uri $registerToolApi `
    -Method POST `
    -Headers $headers `
    -ContentType 'application/json' `
    -Body '{   "tool": "ServerAssessment" }'




# Upload the ZIP file to OffAzure and start import
$importUriUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.OffAzure/masterSites/${masterSiteName}/Import?api-version=${apiVersionOffAzure}"
$importdiscoveredArtifactsResponse = Invoke-RestMethod -Uri $importUriUrl -Method POST -Headers $headers
$blobUri = $importdiscoveredArtifactsResponse.uri
$jobArmId = $importdiscoveredArtifactsResponse.jobArmId

Write-Host "blob URI: $blobUri"
Write-Host "Job ARM ID: $jobArmId"

Write-Host "Uploading ZIP to blob.."
$fileBytes = [System.IO.File]::ReadAllBytes($localZipFilePath)
$uploadBlobHeaders = @{
    "x-ms-blob-type" = "BlockBlob"
    "x-ms-version"   = "2020-04-08"
}
Invoke-RestMethod -Uri $blobUri -Method PUT -Headers $uploadBlobHeaders -Body $fileBytes -ContentType "application/octet-stream"
Write-Host "Done ZIP to blob.."

$jobUrl = "https://management.azure.com${jobArmId}?api-version=${apiVersionOffAzure}"
 
Write-Host "Polling import job status..."
$waitTimeSeconds = 20
$maxAttempts = 50 * (60 / $waitTimeSeconds)  # 50 minutes timeout
$attempt = 0
$jobCompleted = $false
 
do {
    $jobStatus = Invoke-RestMethod -Uri $jobUrl -Method GET -Headers $headers
    $jobResult = $jobStatus.properties.jobResult
    Write-Host "Attempt $($attempt): Job status - $jobResult"

    if ($jobResult -eq "Completed") {
        $jobCompleted = $true
        break
    } elseif ($jobResult -eq "Failed") {
        throw "Import job failed."
    }
 
    Start-Sleep -Seconds $waitTimeSeconds
    $attempt++
} while ($attempt -lt $maxAttempts)
 
if (-not $jobCompleted) {
    throw "Timed out waiting for import job to complete."
} else {
    Write-Host "Import job completed. Imported $importedCount machines."
}