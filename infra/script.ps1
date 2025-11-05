$environmentName = "migv8"

az group create -n ${environmentName}-rg -l swedencentral
az group deployment create -n ${environmentName} `
    -g ${environmentName}-rg `
    --template-file '.\templates\lab197959-template2 (v5).json' `
    --parameters prefix=${environmentName} `
    --debug


# Option 1: Using Azure PowerShell module (for pipeline with service principal)
# Assumes Connect-AzAccount was already done in pipeline
$secureToken = (Get-AzAccessToken -ResourceUrl "https://management.azure.com/").Token
$token = (New-Object PSCredential 0, $secureToken).GetNetworkCredential().Password

$headers=@{} 
$headers.Add("authorization", "Bearer $token") 
$headers.Add("content-type", "application/json") 

# Write-Host "Register Server Discovery"
# $response = Invoke-RestMethod -Uri 'https://management.azure.com/subscriptions/31be0ff4-c932-4cb3-8efc-efa411d79280/resourceGroups/priv…' `
#     -Method POST `
#     -Headers $headers `
#     -ContentType 'application/json' `
#     -Body '{   "tool": "ServerDiscovery" }'

# Write-Host "Register Server Assessment"
# $response = Invoke-RestMethod -Uri 'https://management.azure.com/subscriptions/31be0ff4-c932-4cb3-8efc-efa411d79280/resourceGroups/priv…' `
#     -Method POST `
#     -Headers $headers `
#     -ContentType 'application/json' `
#     -Body '{   "tool": "ServerAssessment" }'

$subscriptionId = "96c2852b-cf88-4a55-9ceb-d632d25b83a4"
$resourceGroup = "$environmentName-rg"
$masterSiteName = "$environmentName-prjmastersite"
$apiVersionOffAzure = "2024-12-01-preview"
$remoteZipFilePath = "https://github.com/crgarcia12/migrate-modernize-lab/raw/refs/heads/main/lab-material/Azure-Migrate-Discovery.zip"
$localZipFilePath = "importArtifacts.zip"

Invoke-WebRequest $remoteZipFilePath -OutFile $localZipFilePath


$importUriUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.OffAzure/masterSites/${masterSiteName}/Import?api-version=${apiVersionOffAzure}"
$importdiscoveredArtifactsResponse = Invoke-RestMethod -Uri $importUriUrl -Method POST -Headers $headers
$blobUri = $importdiscoveredArtifactsResponse.uri
$jobArmId = $importdiscoveredArtifactsResponse.jobArmId
 
Write-Host "Uploading ZIP to blob.."
Invoke-RestMethod -Uri $blobUri -Method Put `
    -InFile $localZipFilePath `
    -ContentType "application/octet-stream" `
    -Headers @{ "x-ms-blob-type" = "BlockBlob" }
 
$jobUrl = "https://management.azure.com${jobArmId}?api-version=${apiVersionOffAzure}"
 
Write-Host "Polling import job status..."
$maxAttempts = 30
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
 
    Start-Sleep -Seconds 20
    $attempt++
} while ($attempt -lt $maxAttempts)
 
if (-not $jobCompleted) {
    throw "Timed out waiting for import job to complete."
} else {
    Write-Host "Import job completed. Imported $importedCount machines."
}