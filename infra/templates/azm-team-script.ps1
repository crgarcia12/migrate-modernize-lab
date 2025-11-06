# Azure Migrate Master Site Import Script
# Uploads discovery data ZIP file to Azure Migrate and monitors import job status

# $importUriUrl = 
# "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.OffAzure/masterSites/${masterSiteName}/Import?api-version=${apiVersionOffAzure}"
# /subscriptions/96c2852b-cf88-4a55-9ceb-d632d25b83a4/resourceGroups/migrl10/providers/Microsoft.OffAzure/masterSites/migrl109371masterSite


param(
    [Parameter()]
    [string]$MasterSiteId = "/subscriptions/03661b75-eaa7-4c91-b02d-2032a4dfed87/resourceGroups/migv22-rg/providers/Microsoft.OffAzure/masterSites/migv22mastersite",
    
    [Parameter()]
    [string]$ZipFilePath = "importArtifacts.zip",
    
    [Parameter()]
    [string]$ApiVersion = "2024-12-01-preview"
)

$ZipFilePath = (gci importArtifacts.zip).FullName

# Option 1: Using Azure PowerShell module (for pipeline with service principal)
# Assumes Connect-AzAccount was already done in pipeline
$token = (Get-AzAccessToken -ResourceUrl "https://management.azure.com/").Token
$token = (New-Object PSCredential 0, $token).GetNetworkCredential().Password

$headers=@{} 
$headers.Add("authorization", "Bearer $token") 
$headers.Add("content-type", "application/json") 

Write-Host "Master Site ID: $MasterSiteId" -ForegroundColor Cyan
Write-Host "Zip File Path: $ZipFilePath" -ForegroundColor Cyan

$masterSiteImportUriUrl = "https://management.azure.com${MasterSiteId}/Import?api-version=${ApiVersion}"
$importdiscoveredArtifactsResponse = Invoke-RestMethod -Uri $masterSiteImportUriUrl -Method POST -Headers $headers
$sasUri = $importdiscoveredArtifactsResponse.uri
$jobArmId = $importdiscoveredArtifactsResponse.jobArmId
Write-Host "Job ARM ID: $jobArmId"
Write-Host "Uploading ZIP to blob.."

# ==== VALIDATE ====
if (-not (Test-Path $ZipFilePath)) {
    Write-Error "Zip file not found at: $ZipFilePath"
    exit 1
}

# ==== UPLOAD ====
try {
    Write-Host "Uploading $ZipFilePath to blob..." -ForegroundColor Cyan
    
    $fileBytes = [System.IO.File]::ReadAllBytes($ZipFilePath)

    # Required headers for blob PUT
    $headers = @{
        "x-ms-blob-type" = "BlockBlob"
        "x-ms-version"   = "2020-04-08"
    }

    # Perform PUT upload
    Invoke-RestMethod -Uri $sasUri -Method PUT -Headers $headers -Body $fileBytes -ContentType "application/octet-stream"

    Write-Host "✅ Upload completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "❌ Upload failed: $($_.Exception.Message)" -ForegroundColor Red
}

$jobUrl = "https://management.azure.com${jobArmId}?api-version=${ApiVersion}"
 
Write-Host "Polling import job status..."
$waitTimeSeconds = 20
$maxAttempts = 45 * (60 / $waitTimeSeconds)  # 45 minutes max
$attempt = 0
$jobCompleted = $false
$headers=@{} 
$headers.Add("authorization", "Bearer $token") 
$headers.Add("content-type", "application/json") 
 
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



 
