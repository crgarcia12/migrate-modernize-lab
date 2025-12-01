# Download and Configure Azure Migrate Script
# This script downloads the New-MicroHackEnvironment.ps1 script from GitHub and executes it
# Designed for non-interactive execution

# Configuration
$ScriptUrl = "https://github.com/crgarcia12/migrate-modernize-lab/raw/refs/heads/main/lab-creation/New-MicroHackEnvironment.ps1"
$ScriptVersion = "9.0.0"

# Environment configuration for this script
$script:DownloadEnvironmentName = "lab@lab.LabInstance.ID"

# Script-level variables to track logging state and buffer (Download script specific)

$script:DownloadLoggingInitialized = $false
$script:DownloadLogBuffer = [System.Text.StringBuilder]::new()
$script:DownloadStorageContext = $null
######################################################
##############   LOGGING FUNCTIONS   ################
######################################################

function Write-DownloadLogToBlob {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # Write to console
    Write-Host $logEntry
    
    $SkillableEnvironment = $true
    
    if ($SkillableEnvironment -eq $false) {
        return
    }

    # Add to memory buffer and immediately write to blob
    try {
        # Add log entry to buffer (download-specific)
        $null = $script:DownloadLogBuffer.AppendLine($logEntry)
        
        # Immediately write entire buffer to blob (overwrite)
        Write-DownloadBufferToBlob
        
    }
    catch {
        Write-Host "Failed to write log to blob: $($_.Exception.Message)" -ForegroundColor Red
        # Fallback to local file if blob fails
        $localLogFile = ".\download-script-execution.log"
        Add-Content -Path $localLogFile -Value $logEntry
    }
}

function Write-DownloadBufferToBlob {
    # Logging configuration constants (Download script specific)
    $DOWNLOAD_STORAGE_SAS_TOKEN = "?sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2026-01-30T22:09:19Z&st=2025-11-05T13:54:19Z&spr=https&sig=mBoL3bVHPGSniTeFzXZ5QdItTxaFYOrhXIOzzM2jvF0%3D"
    $DOWNLOAD_STORAGE_ACCOUNT_NAME = "azmdeploymentlogs"
    $DOWNLOAD_CONTAINER_NAME = "logs"
    $DOWNLOAD_LOG_BLOB_NAME = "$script:DownloadEnvironmentName.download.txt"
    
    # Auto-initialize logging if not already done
    if (-not $script:DownloadLoggingInitialized) {
        
        try {
            # Initialize script-level storage context (download-specific)
            $script:DownloadStorageContext = New-AzStorageContext -StorageAccountName $DOWNLOAD_STORAGE_ACCOUNT_NAME -SasToken $DOWNLOAD_STORAGE_SAS_TOKEN
            
            # Initialize the log buffer with header
            $initialLog = "=== Download Script [$ScriptVersion] execution started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===`nEnvironment: $script:DownloadEnvironmentName`n"
            $null = $script:DownloadLogBuffer.AppendLine($initialLog)
            
            Write-Host "Initialized download log blob: $DOWNLOAD_LOG_BLOB_NAME" -ForegroundColor Green
            $script:DownloadLoggingInitialized = $true
            
        }
        catch {
            Write-Host "Failed to initialize download log blob: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Check if storage account and container exist" -ForegroundColor Red
            Write-Host "Also verify SAS token permissions and expiration" -ForegroundColor Red
            
            # Fallback to local file
            $localLogFile = ".\download-script-execution.log"
            $initialLog = "=== Download Script execution started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===`nEnvironment: $script:DownloadEnvironmentName`n"
            Set-Content -Path $localLogFile -Value $initialLog -NoNewline
            Write-Host "Created local log file as fallback: $localLogFile" -ForegroundColor Yellow
            $script:DownloadLoggingInitialized = $true
        }
    }
    
    # Write the entire buffer content to blob, avoiding read operations
    try {
        if ($script:DownloadStorageContext -and $script:DownloadLogBuffer.Length -gt 0) {
            # Create temp file with buffer content
            $tempFile = "$env:TEMP\$([System.Guid]::NewGuid()).txt"
            Set-Content -Path $tempFile -Value $script:DownloadLogBuffer.ToString() -NoNewline
            
            # Overwrite blob with complete buffer content
            Set-AzStorageBlobContent -File $tempFile -Blob $DOWNLOAD_LOG_BLOB_NAME -Container $DOWNLOAD_CONTAINER_NAME -Context $script:DownloadStorageContext -Force | Out-Null
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Host "Failed to write download buffer to blob: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Set error action preference to stop on errors
$ErrorActionPreference = "Stop"
Write-DownloadLogToBlob "=== Starting download and configuration process ==="

Write-DownloadLogToBlob "Importing Az modules. Make sure ARM modules are not loaded..."
Import-Module Az.Accounts, Az.Resources -Force
Get-Module -Name AzureRM* | Remove-Module -Force

# Check current execution policy and handle automatically
$CurrentExecutionPolicy = Get-ExecutionPolicy
Write-DownloadLogToBlob "Current PowerShell execution policy: $CurrentExecutionPolicy"

try {
    # Create a temporary file path
    $TempScriptPath = Join-Path (Get-Location).Path "New-MicroHackEnvironment.ps1"
    
    Write-DownloadLogToBlob "Downloading script from: $ScriptUrl"
    Write-DownloadLogToBlob "Temporary location: $TempScriptPath"
    Write-DownloadLogToBlob "Subscription ID: '${(Get-AzContext).Subscription.Id}'"

    # Download the script
    Invoke-WebRequest -Uri $ScriptUrl -OutFile $TempScriptPath -UseBasicParsing
    if ($TempScriptPath -and (Test-Path $TempScriptPath)) {
        Write-DownloadLogToBlob "Script downloaded successfully!"
        # Verify the file is not empty
        $FileSize = (Get-Item $TempScriptPath).Length
        if ($FileSize -gt 0) {
            Write-DownloadLogToBlob "File size: $FileSize bytes"

            # Log the first 10 lines of the downloaded script for troubleshooting
            try {
                $PreviewLines = Get-Content -Path $TempScriptPath -TotalCount 10
                if ($PreviewLines -and $PreviewLines.Count -gt 0) {
                    Write-DownloadLogToBlob "First 10 lines of downloaded script:"
                    Write-DownloadLogToBlob ($PreviewLines -join [Environment]::NewLine)
                }
                else {
                    Write-DownloadLogToBlob "Downloaded script appears to be empty when reading content." "WARN"
                }
            }
            catch {
                Write-DownloadLogToBlob "Failed to read first 10 lines of downloaded script: $($_.Exception.Message)" "WARN"
            }

            # Unblock the downloaded file to remove the "downloaded from internet" flag
            Write-DownloadLogToBlob "Unblocking downloaded script..."
            try {
                Unblock-File -Path $TempScriptPath
                Write-DownloadLogToBlob "Script unblocked successfully!"
            }
            catch {
                Write-DownloadLogToBlob "Could not unblock file: $($_.Exception.Message)" "WARN"
                Write-DownloadLogToBlob "Continuing with execution..."
            }
            # Replace <LABINSTANCEID> placeholder with DownloadEnvironmentName
            Write-DownloadLogToBlob "Processing script content to replace placeholders..."
            try {
                $ScriptContent = Get-Content -Path $TempScriptPath -Raw
                if ($ScriptContent -match "<LABINSTANCEID>") {
                    $ModifiedContent = $ScriptContent -replace "<LABINSTANCEID>", $script:DownloadEnvironmentName
                    Set-Content -Path $TempScriptPath -Value $ModifiedContent -NoNewline
                    Write-DownloadLogToBlob "Replaced <LABINSTANCEID> with $script:DownloadEnvironmentName"
                }
                else {
                    Write-DownloadLogToBlob "No <LABINSTANCEID> placeholder found in script."
                }
            }
            catch {
                Write-DownloadLogToBlob "Could not process script content: $($_.Exception.Message)" "WARN"
                Write-DownloadLogToBlob "Continuing with original script..."
            }
            Write-DownloadLogToBlob "Executing downloaded script..."
            . $TempScriptPath

            
            # & pwsh -ExecutionPolicy Bypass -File $TempScriptPath
            Write-DownloadLogToBlob "Downloaded script execution completed!"
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
    Write-DownloadLogToBlob "An error occurred: $($_.Exception.Message)" "ERROR"
    exit 1
}
finally {
    # Clean up the temporary file
    if (Test-Path $TempScriptPath) {
        try {
            Remove-Item $TempScriptPath -Force
            Write-DownloadLogToBlob "Temporary file cleaned up."
        }
        catch {
            Write-DownloadLogToBlob "Could not clean up temporary file: $TempScriptPath" "WARN"
        }
    }
}

Write-DownloadLogToBlob "Download and configure process completed."