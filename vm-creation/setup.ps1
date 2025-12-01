Start-Transcript -Path "setup-logs-$(Get-Date -Format yyyy-MM-dd-HH-mm-ss).txt" -Append
Write-Host "-----------------------------------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "Beginning the deployment process..." -ForegroundColor Yellow
Write-Host "This script will deploy the Contoso Hotel application to the specified VMs." -ForegroundColor Yellow


Write-Host "Installing SQL Server Module" -ForegroundColor Yellow
Install-Module -Name SqlServer -Confirm:$False -Force
Install-Module -Name SqlServerDsc -Confirm:$False -Force
Get-Module SqlServer -ListAvailable
Write-Host "Done Installing SQL Server Module" -ForegroundColor Green

Write-Host "Importing SqlServer module..." -ForegroundColor Yellow
Import-Module SqlServer -Force -DisableNameChecking -ErrorAction SilentlyContinue
Write-Host "SqlServer module imported successfully." -ForegroundColor Green

Write-Host "Importing SqlServerDsc module..." -ForegroundColor Yellow
Import-Module SqlServerDsc -Force -DisableNameChecking -ErrorAction SilentlyContinue
Write-Host "SqlServerDsc module imported successfully." -ForegroundColor Green

# Variables
$VmAdminPassword = "demo!pass123"
$storageAccountName = "crgarciamigrateresources"
$containerName = "migrate-resources"
$decryptedSasToken = 'sp=r&st=2025-09-21T04:41:12Z&se=2025-12-01T13:56:12Z&spr=https&sv=2024-11-04&sr=c&sig=vqpNaDIbt%2Bqcvd3vnOqWj3qhHK5s12707gCJNcoE9A0%3D'
$pythonInstallerUrl = "https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe"
$pythonInstallerPath = "C:\Automation\Contoso\python-installer.exe"
$pythonPath = "C:\Python\Python312"
$requirementsPath = "C:\Automation\Contoso\requirements.txt"
$odbcDriverUrl = "https://go.microsoft.com/fwlink/?linkid=2266640"
$odbcDriverPath = "C:\Automation\Contoso\ODBCDriver18.msi"
$contosoDestinationPath = "C:\inetpub\wwwroot\"
$features = @(
    "Web-WebServer",
    "Web-Static-Content",
    "Web-Http-Errors",
    "Web-Http-Redirect",
    "Web-Stat-Compression",
    "Web-Filtering",
    "Web-Asp-Net45",
    "Web-Net-Ext45",
    "Web-ISAPI-Ext",
    "Web-ISAPI-Filter",
    "Web-Mgmt-Console",
    "Web-Mgmt-Tools",
    "NET-Framework-45-ASPNET",
    "Web-Mgmt-Service",
    "Web-Windows-Auth",
    "Web-CGI",
    "Web-Dyn-Compression",
    "Web-Scripting-Tools",
    "Web-Dyn-Compression"
)
            
# Define the username and password
$username = "builtin\Administrator"
$password = ConvertTo-SecureString $VmAdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $password)
        
# Define the Service Account credentials
$serviceAccountUsername = "demosa"  # Replace with your desired service account username
$serviceAccountPassword = ConvertTo-SecureString $VmAdminPassword -AsPlainText -Force
$serviceAccountCredential = New-Object System.Management.Automation.PSCredential ($serviceAccountUsername, $serviceAccountPassword)
     
$SAUsername = "sa"
$SAPassword = ConvertTo-SecureString $VmAdminPassword -AsPlainText -Force
$SACredential = New-Object System.Management.Automation.PSCredential ($SAUsername, $SAPassword)

$UbuntuUsername = "demoadmin"
$UbuntuPassword = ConvertTo-SecureString $VmAdminPassword -AsPlainText -Force
        
# Base VHDs
$baseVHDs = @{
    "BASE_SERVER_2019.vhd" = "https://$storageAccountName.blob.core.windows.net/$containerName/BASE_SERVER_2019.vhd?$decryptedSasToken"
    "BASE_SERVER_2022.vhd" = "https://$storageAccountName.blob.core.windows.net/$containerName/BASE_SERVER_2022.vhd?$decryptedSasToken"
    "BASE_SERVER_2025.vhd" = "https://$storageAccountName.blob.core.windows.net/$containerName/BASE_SERVER_2025.vhd?$decryptedSasToken"
}
            
# VM Configurations
$vmConfigs = @(
    @{
        BaseVHD = "BASE_SERVER_2025.vhd"
        VMs     = @(
            @{
                Name      = "WEB-2025-100"
                IPAddress = "172.100.2.110"
                SetId     = 2025
            },
            @{
                Name      = "DB-2025-100"
                IPAddress = "172.100.2.111"
                SetId     = 2025
            },
            @{
                Name      = "SRV-2025-100"
                IPAddress = "172.100.2.112"
                SetId     = $null
            }            
        )
    },
    @{
        BaseVHD = "BASE_SERVER_2022.vhd"
        VMs     = @(
            @{
                Name      = "WEB-2022-100"
                IPAddress = "172.100.2.120"
                SetId     = 2022
            },
            @{
                Name      = "DB-2022-100"
                IPAddress = "172.100.2.121"
                SetId     = 2022
            },
            @{
                Name      = "SRV-2022-100"
                IPAddress = "172.100.2.122"
                SetId     = $null
            }            
        )
    },
<#    @{
        BaseVHD = "BASE_SERVER_2019.vhd"
        VMs     = @(
            @{
                Name      = "WEB-2019-100"
                IPAddress = "172.100.2.130"
                SetId     = 2019
            },
            @{
                Name      = "DB-2019-100"
                IPAddress = "172.100.2.131"
                SetId     = 2019
            },
            @{
                Name      = "SRV-2019-100"
                IPAddress = "172.100.2.132"
                SetId     = $null
            }            
        )
    },#>
    @{
        BaseVHD = "ubuntu_installer.iso"
        VMs     = @(
            @{
                Name  = "WEB-U-2204-100"
                SetId = "ubuntu"
            },
            @{
                Name  = "DB-U-2204-100"
                SetId = "ubuntu"
            }
        )
    }
)

$jobVariables = @{
    storageAccountName       = $storageAccountName
    containerName            = $containerName
    decryptedSasToken        = $decryptedSasToken
    pythonInstallerUrl       = $pythonInstallerUrl
    pythonInstallerPath      = $pythonInstallerPath
    pythonPath               = $pythonPath
    requirementsPath         = $requirementsPath
    odbcDriverUrl            = $odbcDriverUrl
    odbcDriverPath           = $odbcDriverPath
    contosoDestinationPath   = $contosoDestinationPath
    features                 = $features
    credential               = $credential
    serviceAccountCredential = $serviceAccountCredential
    SACredential             = $SACredential
    UbuntuUsername           = $UbuntuUsername
    UbuntuPassword           = $UbuntuPassword
    baseVHDs                 = $baseVHDs
    vmConfigs                = $vmConfigs
}

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator."
    exit
}
Write-Host "Verified and deployment is running as Administrator." -ForegroundColor Green
            
function Check-DirectoryExistance {
    param (
        [string]$Path
    )
              
    if (-Not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory
        Write-Output "Directory created: $Path"
                
        $Acl = Get-ACL $Path
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("everyone", "FullControl", "ContainerInherit,Objectinherit", "none", "Allow")
        $Acl.AddAccessRule($AccessRule)
        Set-Acl $SharePath $Acl
        Write-Output "Permissions set for Everyone: Full Control"
    }
    else {
        Write-Output "Directory already exists: $Path"
    }
}
            
function Install-AzCopy {
    $azCopyPath = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"
    if (-Not (Test-Path $azCopyPath)) {
        Write-Output "AzCopy not found. Downloading and installing..."
        $downloadUrl = "https://aka.ms/downloadazcopy-v10-windows"
        $zipFilePath = "$env:TEMP\azcopyv10.zip"
        $installPath = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"
            
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFilePath
        Expand-Archive -Path $zipFilePath -DestinationPath $installPath
            
        $azCopyExecutable = (Get-ChildItem -Path $installPath -Recurse -File -Filter 'azcopy.exe').FullName
        Write-Host "AzCopy installed successfully at $azCopyExecutable."
    }
    else {
        $azCopyExecutable = (Get-ChildItem -Path $azCopyPath -Recurse -File -Filter 'azcopy.exe').FullName
        Write-Host "AzCopy is already installed at $azCopyExecutable."
    }
            
    return $azCopyExecutable
}
            
function Check-VHD {
    param (
        [string]$DestinationVHDPath,
        [string]$VHDFileName,
        [string]$SysprepedVHDUrl
    )
            
    # Combine the directory path and the file name to create the full path
    $fullVHDPath = Join-Path -Path $DestinationVHDPath -ChildPath $VHDFileName
            
    # Ensure the directory exists
    Check-DirectoryExistance $DestinationVHDPath
            
    # Check if the VHD file already exists
    if (-Not (Test-Path -Path $fullVHDPath)) {
        Write-Host "Downloading the syspreped VHD..."
            
        # Ensure AzCopy is installed and get the path to the executable
        $azCopyExecutable = Install-AzCopy
            
        # Construct the full AzCopy command
        $azCopyArgs = @("copy", "$SysprepedVHDUrl", $fullVHDPath)
            
        # Execute the AzCopy command using the call operator
        Write-Host "Executing: $azCopyExecutable $azCopyArgs"
        & $azCopyExecutable @azCopyArgs
            
        Write-Host "VHD downloaded to: $fullVHDPath"
    }
    else {
        Write-Host "VHD already exists: $fullVHDPath"
    }
}
         
function Get-DBServerIP {
    param (
        [Parameter(Mandatory = $true)]
        [int]$SetID,
                
        [Parameter(Mandatory = $true)]
        [array]$VMs
    )
        
    $dbServer = $VMs | Where-Object { $_.SetID -eq $SetID -and $_.Name -like "DB*" }
    if ($dbServer) {
        return $dbServer.IPAddress
    }
    else {
        Write-Error "Database server for SetID $SetID not found in configuration."
        return $null
    }
}
        
function Get-ConnectionString {
    param (
        [Parameter(Mandatory = $true)]
        [int]$SetID,
                
        [Parameter(Mandatory = $true)]
        [array]$VMs,
        
        [Parameter(Mandatory = $true)]
        [SecureString]$SQLPassword
    )
        
    $dbServer = $VMs | Where-Object { $_.SetID -eq $SetID -and $_.Name -like "DB*" }
    if ($dbServer) {
        $connectionString = "Driver={ODBC Driver 18 for SQL Server};Server=$($dbServer.IPAddress);Database=ContosoHotel;Uid=demosa;Pwd=demo!pass123;Encrypt=Optional"
        return $connectionString
    }
    else {
        Write-Error "Database server for SetID $SetID not found in configuration."
        return $null
    }
}

function Wait-ForVMReadiness {
    param (
        [string]$VMName,
        [int]$TimeoutSeconds = 600
    )
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    
    while ($stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds) {
        try {
            $result = Invoke-Command -VMName $VMName -Credential $credential -ScriptBlock { 
                Get-Service -Name 'WinRM' 
            } -ErrorAction Stop
            
            if ($result.Status -eq 'Running') {
                Write-Host "VM $VMName is ready."
                return $true
            }
        }
        catch {
            Write-Host "Waiting for VM $VMName to be ready..."
        }
        
        Start-Sleep -Seconds 10
    }
    
    Write-Host "Timeout waiting for VM $VMName to be ready."
    return $false
}

function Download-UbuntuISO {
    param (
        [string]$DestinationPath,
        [string]$StorageAccountName,
        [string]$ContainerName,
        [string]$SasToken,
        [string]$IsoFileName = "ubuntu_installer.iso"
    )
    
    $output = Join-Path $DestinationPath $IsoFileName
    
    if (!(Test-Path $output)) {
        Write-Host "Ubuntu ISO not found locally. Downloading..." -ForegroundColor Yellow
        
        if (!(Test-Path $DestinationPath)) {
            New-Item -Path $DestinationPath -ItemType Directory -Force | Out-Null
        }
        
        $url = "https://${StorageAccountName}.blob.core.windows.net/${ContainerName}/${IsoFileName}?${SasToken}"
        
        # Ensure AzCopy is installed
        $azCopyPath = "C:\Automation\Contoso\azcopy.exe"
        if (-Not (Test-Path $azCopyPath)) {
            Write-Host "AzCopy not found. Downloading and installing..." -ForegroundColor Yellow
            $azCopyZipPath = "C:\Automation\Contoso\azcopy.zip"
            Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile $azCopyZipPath
            Expand-Archive -Path $azCopyZipPath -DestinationPath "C:\Automation\Contoso\" -Force
            Remove-Item $azCopyZipPath
            $azCopyDir = (Get-ChildItem -Path "C:\Automation\Contoso" -Directory | Where-Object { $_.Name -like 'azcopy_windows_amd64_*' }).FullName
            $azCopyPath = Join-Path $azCopyDir "azcopy.exe"
            Write-Host "AzCopy installed successfully at: $azCopyPath" -ForegroundColor Green
        }
        
        # Verify AzCopy exists
        if (!(Test-Path $azCopyPath)) {
            Write-Host "AzCopy not found at expected location: $azCopyPath" -ForegroundColor Red
            return $null
        }
        
        # Use AzCopy to download the ISO
        Write-Host "Executing AzCopy command: $azCopyPath copy $url $output" -ForegroundColor Yellow
        try {
            $result = & $azCopyPath copy $url $output
            Write-Host "AzCopy Output: $result" -ForegroundColor Cyan
        }
        catch {
            Write-Host "Error executing AzCopy: $_" -ForegroundColor Red
            return $null
        }

        if (Test-Path $output) {
            Write-Host "Ubuntu ISO downloaded successfully." -ForegroundColor Green
        }
        else {
            Write-Host "Failed to download Ubuntu ISO." -ForegroundColor Red
            return $null
        }
    }
    else {
        Write-Host "Ubuntu ISO already exists locally. Skipping download." -ForegroundColor Green
    }
    
    return $output
}

# The rest of the functions and main script remain the same as in the previous response

function Wait-UbuntuInstallation {
    param (
        [string]$VMName,
        [int]$TimeoutMinutes = 60
    )

    $timeout = New-TimeSpan -Minutes $TimeoutMinutes
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $lastStatus = ""
    $iteration = 0

    while ($stopwatch.Elapsed -lt $timeout) {
        $iteration++
        $vm = Get-VM -VMName $VMName
        $vmStatus = $vm.State
        $ipAddress = (Get-VMNetworkAdapter -VMName $VMName).IPAddresses | Where-Object { $_ -match '^\d{1,3}(\.\d{1,3}){3}$' } | Select-Object -First 1

        if ($vmStatus -ne $lastStatus) {
            Write-Host "VM '$VMName' status: $vmStatus" -ForegroundColor Yellow
            $lastStatus = $vmStatus
        }

        if ($ipAddress) {
            Write-Host "VM '$VMName' IP address: $ipAddress" -ForegroundColor Green
            Write-Host "Ubuntu installation completed for VM '$VMName'." -ForegroundColor Green
            return $ipAddress
        }
        else {
            Write-Host "Iteration '$iteration': Waiting for VM '$VMName' to receive an IP address..." -ForegroundColor Yellow
        }

        Start-Sleep -Seconds 30
    }

    Write-Host "Timeout waiting for Ubuntu installation to complete on VM '$VMName'" -ForegroundColor Red
    return $null
}

function New-UbuntuVM {
    param (
        [string]$VMName,
        [string]$VMPath,
        [string]$VHDPath,
        [int64]$VHDSize,
        [int64]$MemoryStartupBytes,
        [string]$SwitchName,
        [string]$ISOPath
    )

    Write-Host "Creating Ubuntu VM: $VMName..." -ForegroundColor Yellow
    
    # Create the VM
    New-VM -Name $VMName -Generation 1 -MemoryStartupBytes $MemoryStartupBytes -NewVHDPath $VHDPath -NewVHDSizeBytes $VHDSize -Path $VMPath -SwitchName $SwitchName
    
    # Set the DVD drive to use the ISO
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath
    
    # Set boot order (IDE first for Gen 1 VMs)
    Set-VMBios -VMName $VMName -StartupOrder @("IDE", "CD", "LegacyNetworkAdapter", "Floppy")
    
    # Start the VM
    Start-VM -Name $VMName
}

function Set-UbuntuHostname {
    param (
        [string]$VMName,
        [string]$IPAddress,
        [string]$Username,
        [SecureString]$Password
    )

    Write-Host "Configuring VM: $VMName" -ForegroundColor Yellow

    # Check if POSH-SSH module is available and install if necessary
    if (-not (Get-Module -ListAvailable -Name POSH-SSH)) {
        Write-Host "Installing POSH-SSH module..." -ForegroundColor Yellow
        Install-Module -Name POSH-SSH -Force -Scope CurrentUser
    }

    # Import the POSH-SSH module
    Import-Module POSH-SSH

    # Create credentials object
    $credentials = New-Object System.Management.Automation.PSCredential ($Username, $Password)

    $plainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))

    try {
        # Establish SSH session
        $sshSession = New-SSHSession -ComputerName $IPAddress -Credential $credentials -AcceptKey

        if ($sshSession.Connected) {
            Write-Host "Connected successfully to $IPAddress" -ForegroundColor Green

            # Define the commands to run (including sudo commands)
            $commands = @(
                "echo $plainTextPassword | sudo -S apt-get update",
                "echo $plainTextPassword | sudo -S apt-get upgrade -y",
                "echo $plainTextPassword | sudo -S hostnamectl set-hostname $VMName",
                "echo $plainTextPassword | sudo -S reboot"
            )

            # Execute each command
            foreach ($cmd in $commands) {
                $result = Invoke-SSHCommand -SSHSession $sshSession -Command $cmd
                if ($result.ExitStatus -eq 0) {
                    Write-Host "Command succeeded: $cmd" -ForegroundColor Green
                    Write-Host $result.Output
                }
                else {
                    Write-Host "Command failed: $cmd" -ForegroundColor Red
                    Write-Host $result.Error
                    return $false
                }
            }

            Write-Host "Hostname configuration and updates applied to $VMName" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "Failed to connect to $IPAddress" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
        return $false
    }
    finally {
        # Disconnect and remove the SSH session
        if ($sshSession) {
            Remove-SSHSession -SSHSession $sshSession | Out-Null
        }
    }
}

function Configure-WebVM {
    param($vm, $config)
    $vmName = $vm.Name
    $ipAddress = $vm.IPAddress

    # Generate connection string
    $connectionString = Get-ConnectionString -SetID $vm.SetID -VMs $config.VMs -SQLPassword $serviceAccountPassword
    Write-Host "Connection String: $connectionString" -ForegroundColor Yellow

    # Get the DB Server IP
    $dbServerIP = Get-DBServerIP -SetID $vm.SetID -VMs $config.VMs
    Write-Host "DB Server IP: $dbServerIP"

    if ($dbServerIP) {
        Write-Host "Configuring Web Server: $vmName..." -ForegroundColor Yellow
        
        # Main configuration
        Invoke-Command -VMName $vmName -Credential $credential -ScriptBlock {
            # Variables that need $using:
            $pythonInstallerUrl = $using:pythonInstallerUrl
            $pythonInstallerPath = $using:pythonInstallerPath
            $pythonPath = $using:pythonPath
            $requirementsPath = $using:requirementsPath
            $odbcDriverUrl = $using:odbcDriverUrl
            $odbcDriverPath = $using:odbcDriverPath
            $features = $using:features
            $storageAccountName = $using:storageAccountName
            $containerName = $using:containerName
            $decryptedSasToken = $using:decryptedSasToken
            $contosoDestinationPath = $using:contosoDestinationPath
            $connectionString = $using:connectionString

            # Function to save the Connection String
            function Save-ConnectionString {
                param (
                    [string]$ConnectionString
                )
            
                $directoryPath = "C:\inetpub\wwwroot\ContosoHotel-master\secrets-store"
                $filePath = Join-Path $directoryPath "MSSQL_CONNECTION_STRING"
            
                # Create directory if it doesn't exist
                if (-not (Test-Path $directoryPath)) {
                    New-Item -ItemType Directory -Path $directoryPath -Force | Out-Null
                    Write-Host "Created directory: $directoryPath" -ForegroundColor Yellow
                }
            
                # Create UTF-8 encoding without BOM
                $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            
                # Save connection string to file
                [System.IO.File]::WriteAllText($filePath, $ConnectionString, $Utf8NoBomEncoding)
                Write-Host "Connection string saved to: $filePath" -ForegroundColor Green
            } 

            # Call the function to save the connection string
            Save-ConnectionString -ConnectionString $connectionString

            # Create directory if it doesn't exist
            if (-not (Test-Path -Path "C:\Automation\Contoso")) {
                New-Item -Path "C:\Automation\Contoso" -ItemType Directory -Verbose
            }
    
            # Ensure AzCopy is installed
            if (-Not (Test-Path "C:\Automation\Contoso\azcopy.exe" -Verbose)) {
                Write-Host "Downloading AzCopy..."
                Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile "C:\Automation\Contoso\azcopy.zip" -Verbose
                Expand-Archive -Path "C:\Automation\Contoso\azcopy.zip" -DestinationPath 'C:\Automation\Contoso\' -Verbose -Force
            }

            Write-Host "Disabling Windows Firewall..." -ForegroundColor Yellow
            Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
            Write-Host "Windows Firewall successfully disabled." -ForegroundColor Green

            # Download requirements.txt from Azure Storage
            Write-Host "Downloading requirements.txt from Azure Storage..." -ForegroundColor Yellow
            & 'C:\Automation\Contoso\azcopy_windows_amd64_*/azcopy.exe' copy "https://$storageAccountName.blob.core.windows.net/$containerName/requirements.txt?$decryptedSasToken" "C:\Automation\Contoso\requirements.txt"
            Write-Host "requirements.txt downloaded successfully." -ForegroundColor Green

            # Install IIS and required features
            Write-Host "Installing IIS and required features..." -ForegroundColor Yellow
            Install-WindowsFeature -Name $features -IncludeManagementTools -Verbose
            Write-Host "IIS and required features installed successfully." -ForegroundColor Green
    
            # Download and Install Python
            Write-Host "Downloading and Installing Python..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $pythonInstallerPath -Verbose
            Start-Process -FilePath $pythonInstallerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 TargetDir=$pythonPath" -NoNewWindow -Wait -Verbose
            Write-Host "Python installed successfully." -ForegroundColor Green
    
            # Verify Python Installation
            if (Test-Path "$pythonPath\python.exe" -Verbose) {
                Write-Host "Python installed successfully." -ForegroundColor Green
            }
            else {
                Write-Host "Python installation failed." -ForegroundColor Red
                exit
            }
    
            # Install necessary Python packages from requirements.txt
            Write-Host "Installing necessary Python packages..." -ForegroundColor Yellow
            & "$pythonPath\python.exe" -m pip install --upgrade pip --no-warn-script-location
            & "$pythonPath\python.exe" -m pip install -r $requirementsPath --no-warn-script-location
            Write-Host "Python packages installed successfully." -ForegroundColor Green

            # Install ODBC Driver 18 for SQL Server
            Write-Host "Installing ODBC Driver 18 for SQL Server..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $odbcDriverUrl -OutFile $odbcDriverPath -Verbose
            Start-Process msiexec.exe -ArgumentList "/i", $odbcDriverPath, "/quiet", "/norestart", "/passive", "/qn", "IACCEPTMSODBCSQLLICENSETERMS=YES", "ADDLOCAL=ALL" -NoNewWindow -Wait -Verbose
            Write-Host "ODBC Driver 18 for SQL Server installed successfully." -ForegroundColor Green
            
            # Define the GitHub repository and branch
            $repoOwner = "qxsch"
            $repoName = "ContosoHotel"
            $branch = "master"

            # Construct Contoso Hotel the download URL
            $downloadUrl = "https://github.com/$repoOwner/$repoName/archive/refs/heads/$branch.zip"

            # Download the repository as a zip file
            $zipPath = Join-Path $env:TEMP "$repoName.zip"
            Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

            # Extract the contents
            Expand-Archive -Path $zipPath -DestinationPath $contosoDestinationPath -Force

            # Remove the zip file
            Remove-Item $zipPath

            Write-Host "Repository contents downloaded and extracted to $contosoDestinationPath" -ForegroundColor Green

            Write-Host "Copying the wfastcgi.py file to ContosoHotel Folder"
            Copy-Item -Path "C:\Python\Python312\Lib\site-packages\wfastcgi.py" -Destination "C:\inetpub\wwwroot\ContosoHotel-master" -Force -Verbose
    
            # Set permissions for IIS
            Write-Host "Setting permissions for IIS..." -ForegroundColor Yellow
            icacls $contosoDestinationPath /grant "NT AUTHORITY\IUSR:(OI)(CI)(RX)"
            icacls $contosoDestinationPath /grant "Builtin\IIS_IUSRS:(OI)(CI)(RX)"
            Write-Host "Permissions set for IIS." -ForegroundColor Green
              
            cmd /c start /wait msiexec /quiet /passive /qn /i $pythonInstallerPath IACCEPTMSODBCSQLLICENSETERMS=YES

            # Enable Remote Desktop
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

            # Disable NLA (Network Level Authentication)
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 0

            # Enable RemoteApp
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fAllowToGetHelp" -Value 1

            # Restart the Terminal Server service to apply changes
            Restart-Service -Name TermService -Force

            Write-Host "Remote Desktop has been enabled and NLA has been disabled. The Terminal Server service has been restarted." -ForegroundColor Green
        }

        # IIS and FastCGI Configuration
        Invoke-Command -VMName $vmName -Credential $credential -ScriptBlock {
            $pythonPath = $using:pythonPath
            $contosoDestinationPath = $using:contosoDestinationPath
            $ipAddress = $using:ipAddress
            
            # Adds FastCGI process pools in IIS (Root Level)
            function Add-FastCgiApplication($fullPath, $arguments) {
                $configPath = Get-WebConfiguration 'system.webServer/fastCgi/application' | 
                Where-Object { $_.fullPath -eq $fullPath -and $_.arguments -eq $arguments }
                if (!$configPath) {
                    Add-WebConfiguration 'system.webServer/fastCgi' -Value @{
                        'fullPath'  = $fullPath
                        'arguments' = $arguments
                    }
                    Write-Host "Added FastCGI application: $fullPath $arguments" -ForegroundColor Green
                }
                else {
                    Write-Host "FastCGI application already exists: $fullPath $arguments" -ForegroundColor Blue
                }
            }
 
            # Configure the FastCGI Settings and Environment Variables (Root Level)
            function Set-FastCgiSettings($fullPath, $arguments, $envVars) {
                $configPath = "system.webServer/fastCgi/application[@fullPath='$fullPath'][@arguments='$arguments']"
                Set-WebConfigurationProperty $configPath -Name instanceMaxRequests -Value 200
                Set-WebConfigurationProperty $configPath -Name maxInstances -Value 0
          
                # Add environment variables
                if ($envVars) {
                    $envVarPath = "$configPath/environmentVariables"
                    foreach ($var in $envVars.GetEnumerator()) {
                        $existingVar = Get-WebConfiguration "$envVarPath/environmentVariable[@name='$($var.Name)']"
                        if (-not $existingVar) {
                            Add-WebConfiguration $envVarPath -Value @{
                                'Name'  = $var.Name
                                'Value' = $var.Value
                            }
                            Write-Host "Added environment variable: $($var.Name) = $($var.Value)" -ForegroundColor Green
                        }
                        else {
                            Set-WebConfigurationProperty "$envVarPath/environmentVariable[@name='$($var.Name)']" -Name "value" -Value $var.Value
                            Write-Host "Updated environment variable: $($var.Name) = $($var.Value)" -ForegroundColor Green
                        }
                    }
                }
          
                Write-Host "Configured settings for: $fullPath $arguments" -ForegroundColor Green
            }

            # Configure FastCGI in IIS
            Write-Host "Configuring FastCGI in IIS on VM '$using:vmName' ..."
            $contosoWebSitePath = Join-Path $contosoDestinationPath "ContosoHotel-master"
            $pythonFullPath = Join-Path $pythonPath "\python.exe"
            $wfastcgiPath1 = 'C:\Python\Python312\Lib\site-packages\wfastcgi.py'
            $wfastcgiPath2 = 'C:\inetpub\wwwroot\ContosoHotel-master\wfastcgi.py'
            $scriptProcessor = "$pythonFullPath|$wfastcgiPath2"
            Import-Module WebAdministration -Verbose

            # Add both FastCGI applications
            Add-FastCgiApplication -fullPath $pythonFullPath -arguments $wfastcgiPath1
            Add-FastCgiApplication -fullPath $pythonFullPath -arguments $wfastcgiPath2
                      
            # Configure settings for both FastCGI applications
            Set-FastCgiSettings -fullPath $pythonFullPath -arguments $wfastcgiPath1 -envVars $null
                      
            # Configure settings and environment variables for the second FastCGI application
            $envVars = @{
                "PYTHONPATH"   = "C:\inetpub\wwwroot\ContosoHotel-master"
                "WSGI_HANDLER" = "startup.app"  # Adjust this to match your WSGI application
            }
            Set-FastCgiSettings -fullPath $pythonFullPath -arguments $wfastcgiPath2 -envVars $envVars
    
            # Configure IIS Site
            Write-Host "Configuring IIS site..." -ForegroundColor Yellow
            Set-ItemProperty "IIS:\sites\Default Web Site" -name physicalPath -value $contosoWebSitePath -Verbose
            $existingBinding = Get-WebBinding -Name "Default Web Site" | Where-Object { $_.bindingInformation -like "*:80:*" } -Verbose
            if ($existingBinding) {
                Set-WebBinding -Name "Default Web Site" -BindingInformation $existingBinding.bindingInformation -PropertyName IPAddress -Value $ipAddress -Verbose
                Write-Host "Updated binding on port 80 for Default Web Site." -ForegroundColor Green
            }
            else {
                Write-Host "No binding found on port 80 for Default Web Site. Creating new binding." -ForegroundColor Blue
                New-WebBinding -Name "Default Web Site" -IPAddress $ipAddress -Port 80 -Protocol "http" -Verbose
                Write-Host "Created new binding on port 80 for Default Web Site." -ForegroundColor Green
            }

            # Create web handler
            function New-WebHandlerWithRetry {
                param (
                    [string]$Name,
                    [string]$Path,
                    [string]$Verb,
                    [string]$Modules,
                    [string]$ScriptProcessor,
                    [string]$PSPath,
                    [int]$MaxRetries = 3,
                    [int]$RetryIntervalSeconds = 5
                )
                
                $retryCount = 0
                $success = $false
                $lastError = $null
                
                while (-not $success -and $retryCount -lt $MaxRetries) {
                    if (Get-WebHandler -Name $Name -ErrorAction SilentlyContinue) {
                        Write-Host "Web handler '$Name' already exists. No action needed."
                        return
                    }
            
                    try {
                        New-WebHandler -Name $Name -Path $Path -Verb $Verb -Modules $Modules -ScriptProcessor $ScriptProcessor -PSPath $PSPath
                        $success = $true
                        Write-Host "Web handler '$Name' created successfully."
                    }
                    catch {
                        $retryCount++
                        $lastError = $_
                        Write-Warning "Attempt $retryCount failed. Error: $($_.Exception.Message)"
                        if ($retryCount -lt $MaxRetries) {
                            Write-Warning "Retrying in $RetryIntervalSeconds seconds..."
                            Start-Sleep -Seconds $RetryIntervalSeconds
                        }
                    }
                }
                
                if (-not $success) {
                    Write-Error "Failed to create web handler '$Name' after $MaxRetries attempts. Last error: $($lastError.Exception.Message)"
                    Write-Error "Full error details:"
                    Write-Error $lastError
                    throw $lastError
                }
            }

            Write-Host "Creating web handler..."
            try {
                New-WebHandlerWithRetry -Name "FlaskHandler" -Path "*" -Verb "*" -Modules FastCgiModule -ScriptProcessor "$pythonFullPath|$wfastcgiPath2" -PSPath "IIS:\sites\Default Web Site"
            }
            catch {
                Write-Error "Failed to create web handler. Error: $_"
                # Handle the error as needed
            }
        }

        # API Setup
        Invoke-Command -VMName $vmName -Credential $credential -ScriptBlock {
            $ipAddress = $using:ipAddress
            
            $url = "http://${ipAddress}/api/setup"
            
            try {
                $response = Invoke-RestMethod -Uri $url -Method Post -Body '{ "drop_schema" : true, "create_schema": true, "populate_data" : true }' -ContentType 'application/json'
                Write-Output "Success: $($response | ConvertTo-Json)"
            }
            catch {
                Write-Output "Error: $($_.Exception.Response.StatusCode.value__)"
                Write-Output "Details: $($_.ErrorDetails.Message)"
            }
        }
    }
}

function Configure-DBVM {
    param($vm, $config)
    $vmName = $vm.Name
    $ipAddress = $vm.IPAddress

    if ($vm.SetId -eq "ubuntu") {
       Write-Host "Skipping readiness check for Ubuntu VM: $($vm.Name)" -ForegroundColor Yellow
       continue
    }

    # Step 1: Install Modules
    Write-Host "Installing modules on VM: $vmName..." -ForegroundColor Yellow
    Invoke-Command -VMName $vmName -Credential $credential -ScriptBlock {
        try {
            # Install NuGet provider if not present
            Write-Host "Installing NuGet provider..." -ForegroundColor Yellow
            Install-PackageProvider -Name NuGet -Force -Scope AllUsers -MinimumVersion 2.8.5.208 -Confirm:$false -Verbose
            Write-Host "NuGet provider installed successfully." -ForegroundColor Green

            # Set PSGallery as trusted
            Write-Host "Setting PSGallery as trusted repository..." -ForegroundColor Yellow
            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose
            Write-Host "PSGallery is now a trusted repository." -ForegroundColor Green  

            # Install modules without prompts
            Write-Host "Installing SQLServer module..." -ForegroundColor Yellow
            Install-Module -Name SQLServer -Force -Verbose -Scope AllUsers -AllowClobber
            Write-Host "SQLServer module installed successfully." -ForegroundColor Green

            Write-Host "Installing SqlServerDsc module..." -ForegroundColor Yellow
            Install-Module -Name SqlServerDsc -Force -Verbose -Scope AllUsers -AllowClobber
            Write-Host "SqlServerDsc module installed successfully." -ForegroundColor Green

            # Import modules
            Write-Host "Importing SQLServer module..." -ForegroundColor Yellow
            Import-Module SQLServer -ErrorAction Stop -Verbose
            Write-Host "SQLServer module imported successfully." -ForegroundColor Green

            Write-Host "Importing SqlServerDsc module..." -ForegroundColor Yellow
            Import-Module SqlServerDsc -ErrorAction Stop -Verbose
            Write-Host "SqlServerDsc module imported successfully." -ForegroundColor Green

            # Verify module import
            if (Get-Module -Name SQLServer -ListAvailable) {
                Write-Host "SQLServer module imported successfully." -ForegroundColor Green
            }
            else {
                Write-Error "Failed to import SQLServer module."
            }

            if (Get-Module -Name SqlServerDsc -ListAvailable) {
                Write-Host "SqlServerDsc module imported successfully." -ForegroundColor Green
            }
            else {
                Write-Error "Failed to import SqlServerDsc module."
            }
        }
        catch {
            Write-Error "An error occurred: $_"
        }

        # Enable Remote Desktop
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

        # Disable NLA (Network Level Authentication)
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 0

        # Enable RemoteApp
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fAllowToGetHelp" -Value 1

        # Restart the Terminal Server service to apply changes
        Restart-Service -Name TermService -Force

        Write-Host "Remote Desktop has been enabled and NLA has been disabled. The Terminal Server service has been restarted."                
    }

    # Step 2: Initialize and Apply Configuration
    Write-Host "Initializing and applying configuration for VM: $vmName..." -ForegroundColor Yellow
    Invoke-Command -VMName $vmName -Credential $credential -ScriptBlock {
        param ($storageAccountName, $containerName, $decryptedSasToken, $vmName, $credential, $serviceAccountCredential, $SACredential)
        $storageAccountName = $using:storageAccountName
        $containerName = $using:containerName
        $decryptedSasToken = $using:decryptedSasToken
        $vmName = $using:vmName
        $credential = $using:credential
        $serviceAccountCredential = $using:serviceAccountCredential
        $SACredential = $using:SACredential
                
        # Create directory if it doesn't exist
        if (-not (Test-Path -Path "C:\Automation\SQL")) {
            New-Item -Path "C:\Automation\SQL" -ItemType Directory -Verbose
        }

        # Ensure AzCopy is installed
        if (-Not (Test-Path "C:\Automation\SQL\azcopy.exe")) {
            Write-Host "Downloading AzCopy..."
            Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile "C:\Automation\SQL\azcopy.zip" -Verbose
            Expand-Archive -Path "C:\Automation\SQL\azcopy.zip" -DestinationPath 'C:\Automation\SQL\' -Verbose -Force
        }
                
        # Disable Firewall for WebApp connection
        Write-Host "Disabling Windows Firewall..." -ForegroundColor Yellow
        Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
                
        # Download SQL Server ISO using AzCopy
        Write-Host "Downloading SQL Server ISO..." -ForegroundColor Yellow
        $sqlServerIsoPath = "C:\Automation\SQL\SQL_SERVER_2022.iso"
        & 'C:\Automation\SQL\azcopy_windows_amd64_*/azcopy.exe' copy "https://$storageAccountName.blob.core.windows.net/$containerName/SQL_SERVER_2022.iso?$decryptedSasToken" $sqlServerIsoPath

        # Mount SQL Server ISO
        Write-Host "Mounting SQL Server ISO..." -ForegroundColor Yellow
        $mountResult = Mount-DiskImage -ImagePath $sqlServerIsoPath -PassThru
        $driveLetter = ($mountResult | Get-Volume).DriveLetter
        $sqlInstallMedia = $driveLetter + ":\"

        # Define the configuration data
        $ConfigurationData = @{
            AllNodes = @(
                @{
                    NodeName                    = $vmName
                    PSDscAllowPlainTextPassword = $true
                    PSDscAllowDomainUser        = $true
                }
            )
        }

        Configuration SQLServerInstall {
            param(
                [string]$NodeName,
                [string]$SourcePath,
                [Parameter(Mandatory = $true)][System.Management.Automation.PSCredential]$ServiceAccountCredential,
                [Parameter(Mandatory = $true)][System.Management.Automation.PSCredential]$SqlAdminCredential,
                [Parameter(Mandatory = $true)][System.Management.Automation.PSCredential]$SACredential

            )
            Import-DscResource -ModuleName PSDesiredStateConfiguration
            Import-DscResource -ModuleName SqlServerDsc

            Node $NodeName {
                WindowsFeature 'NetFramework45' {
                    Name   = 'NET-Framework-45-Core'
                    Ensure = 'Present'
                }

                SqlSetup 'InstallDefaultInstance' {
                    InstanceName        = 'MSSQLSERVER'
                    Features            = 'SQLENGINE'
                    SourcePath          = $SourcePath
                    SecurityMode        = 'SQL'
                    SAPwd               = $SACredential
                    SQLSysAdminAccounts = @('Administrators')
                 
                }

                SqlLogin 'AddServiceAccount' {
                    Ensure               = 'Present'
                    Name                 = $ServiceAccountCredential.UserName
                    LoginType            = 'SqlLogin'
                    ServerName           = $NodeName
                    InstanceName         = 'MSSQLSERVER'
                    LoginCredential      = $ServiceAccountCredential
                    LoginMustChangePassword = $false
                    LoginPasswordExpirationEnabled = $false
                    LoginPasswordPolicyEnforced = $false
                    PsDscRunAsCredential = $SqlAdminCredential
                    DependsOn            = '[SqlSetup]InstallDefaultInstance'
                }

                SqlRole 'AddSysadminRole' {
                    Ensure               = 'Present'
                    ServerRoleName       = 'sysadmin'
                    MembersToInclude     = $ServiceAccountCredential.UserName
                    ServerName           = $NodeName
                    InstanceName         = 'MSSQLSERVER'
                    PsDscRunAsCredential = $SqlAdminCredential
                    DependsOn            = '[SqlLogin]AddServiceAccount'
                }

                SqlDatabase 'CreateContosoDatabase'
                {
                    Ensure               = 'Present'
                    ServerName           = $NodeName
                    InstanceName         = 'MSSQLSERVER'
                    Name                 = 'ContosoHotel'
                    PsDscRunAsCredential = $SqlAdminCredential
                    DependsOn            = '[SqlSetup]InstallDefaultInstance'

                }

                SqlMemory 'Set_SQLServerMaxMemory_To12GB'
                {
                    Ensure               = 'Present'
                    DynamicAlloc         = $false
                    MinMemory            = 1024
                    MaxMemory            = 12288
                    ServerName           = $NodeName
                    InstanceName         = 'MSSQLSERVER'
                    PsDscRunAsCredential = $SqlAdminCredential
                }
            }
        }

        # Compile the configuration
        SQLServerInstall -ConfigurationData $ConfigurationData -OutputPath "C:\DSC\SQLServerInstall" -NodeName $vmName -SourcePath $sqlInstallMedia -ServiceAccountCredential $serviceAccountCredential -SqlAdminCredential $credential -SACredential $SACredential

        # Apply the configuration
        Start-DscConfiguration -Path "C:\DSC\SQLServerInstall" -Wait -Force -Verbose
        # Dismount SQL Server ISO
        Write-Host "Dismounting SQL Server ISO..." -ForegroundColor Yellow
        Dismount-DiskImage -ImagePath $sqlServerIsoPath

        # SSMS Installation
        $filepath = "C:\Automation\SQL\SSMS-Setup-ENU.exe"
        if (!(Test-Path $filepath)) {
            Write-Host "Downloading SQL Server SSMS..." -ForegroundColor Yellow
            $URL = "https://aka.ms/ssmsfullsetup"
            $clnt = New-Object System.Net.WebClient
            $clnt.DownloadFile($url, $filepath)
            Write-Host "SSMS installer download complete" -ForegroundColor Green
        }
        else {
            Write-Host "Located the SQL SSMS Installer binaries, moving on to install..."
        }

        # Start the SSMS installer
        Write-Host "Beginning SSMS install..." -NoNewline -ForegroundColor Yellow
        $Parms = " /Install /Quiet /Norestart /Logs log.txt"
        $Prms = $Parms.Split(" ")
        & "$filepath" $Prms | Out-Null
        Write-Host "SSMS installation complete" -ForegroundColor Green

        Write-Host "SQL Server and SSMS installation completed."
    } -ArgumentList $storageAccountName, $containerName, $decryptedSasToken, $vmName, $credential, $serviceAccountCredential, $SACredential
}

function Configure-OtherVM {
    param($vm, $config)
    $vmName = $vm.Name
    $ipAddress = $vm.IPAddress

    if ($vm.SetId -eq "ubuntu") {
        Write-Host "Configuring Ubuntu VM: $vmName..." -ForegroundColor Yellow
        $isoPath = Download-UbuntuISO -DestinationPath "C:\Automation\Ubuntu" `
            -StorageAccountName $storageAccountName `
            -ContainerName $containerName `
            -SasToken $decryptedSasToken
        
        if ($null -eq $isoPath) {
            Write-Host "Failed to obtain Ubuntu ISO. Skipping Ubuntu VM creation." -ForegroundColor Red
            return
        }
        
        $VMPath = "E:\Hyper-V\Virtual Machines"
        $VHDPath = "E:\Hyper-V\Virtual Hard Disks\$vmName.vhdx"
        $VHDSize = 40GB
        $MemoryStartupBytes = 4GB
        
        New-UbuntuVM -VMName $vmName -VMPath $VMPath -VHDPath $VHDPath -VHDSize $VHDSize -MemoryStartupBytes $MemoryStartupBytes -SwitchName "NestedSwitch" -ISOPath $isoPath
        
        $ipAddress = Wait-UbuntuInstallation -VMName $vmName -TimeoutMinutes 60

        if ($ipAddress) {
            $hostnameSet = Set-UbuntuHostname -VMName $vmName -IPAddress $ipAddress -Username $UbuntuUsername -Password $UbuntuPassword
            if (-not $hostnameSet) {
                Write-Host "Failed to set hostname for $vmName." -ForegroundColor Red
            }
        }
        else {
            Write-Host "Failed to complete Ubuntu installation on VM: $vmName." -ForegroundColor Red
        }
    }
    else {
        Write-Host "Configuring Windows Server: $vmName..." -ForegroundColor Yellow
        Invoke-Command -VMName $vmName -Credential $credential -ScriptBlock {
            try {
                Write-Host "Enabling Remote Desktop..." -ForegroundColor Yellow
                # Enable Remote Desktop
                Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

                # Disable NLA (Network Level Authentication)
                Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 0

                # Enable RemoteApp
                Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fAllowToGetHelp" -Value 1

                # Restart the Terminal Server service to apply changes
                Restart-Service -Name TermService -Force

                Write-Host "Remote Desktop has been enabled and NLA has been disabled. The Terminal Server service has been restarted." 

                # Disable Firewall for WebApp connection
                Write-Host "Disabling Windows Firewall..." -ForegroundColor Yellow
                Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
                Write-Host "Windows Server configuration completed." -ForegroundColor Green
            }
            catch {
                Write-Error "An error occurred: $_"
            }
        }
    }
}
            

# Install modules
Write-Host "Importing SQLServer module..." -ForegroundColor Yellow
Install-Module SQLServer -ErrorAction Stop -Verbose
Write-Host "SQLServer module imported successfully." -ForegroundColor Green

Write-Host "Importing SqlServerDsc module..." -ForegroundColor Yellow
Install-Module SqlServerDsc -ErrorAction Stop -Verbose
Write-Host "SqlServerDsc module imported successfully." -ForegroundColor Green


# Import modules
Write-Host "Importing SQLServer module..." -ForegroundColor Yellow
Import-Module SQLServer -ErrorAction Stop -Verbose
Write-Host "SQLServer module imported successfully." -ForegroundColor Green

Write-Host "Importing SqlServerDsc module..." -ForegroundColor Yellow
Import-Module SqlServerDsc -ErrorAction Stop -Verbose
Write-Host "SqlServerDsc module imported successfully." -ForegroundColor Green

$scriptStartTime = Get-Date
Write-Host "Script started at: $scriptStartTime" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

           
# Download and copy base VHDs
foreach ($baseVHD in $baseVHDs.GetEnumerator()) {
    $vhdFileName = $baseVHD.Key
    $sysprepedVHDUrl = $baseVHD.Value
    $destinationVHDPath = "E:\Hyper-V\vhd"
    $fullVHDPath = Join-Path -Path $destinationVHDPath -ChildPath $vhdFileName

    if ($vm.SetId -eq "ubuntu") {
        Write-Host "Skipping readiness check for Ubuntu VM: $($vm.Name)" -ForegroundColor Yellow
        continue
    }

    Check-VHD -DestinationVHDPath $destinationVHDPath -VHDFileName $vhdFileName -SysprepedVHDUrl $sysprepedVHDUrl

    # Copy the syspreped VHD to the final drive
    $finalVHDPath = "E:\BaseVHD\"
    Check-DirectoryExistance -Path $finalVHDPath
    Copy-Item -Path $fullVHDPath -Destination $finalVHDPath -Force -Verbose
} 

# Create VMs in parallel
$vmCreationJobs = @()

foreach ($config in $vmConfigs) {
    $baseVHD = $config.BaseVHD

    if ($baseVHD -eq "ubuntu_installation.iso") {
        Write-Host "Skipping $baseVHD as it handled in a different way." -ForegroundColor Cyan
        continue
    }

    $finalVHD = Join-Path -Path "E:\BaseVHD\" -ChildPath $baseVHD
  
    foreach ($vm in $config.VMs) {
        $vmName = $vm.Name
        $vmPath = "E:\Hyper-V\$vmName"
        $vhdPath = "E:\Hyper-V\Virtual Hard Disks\$vmName\$vmName.vhd"
        $ipAddress = $vm.IPAddress

        if ($vm.SetId -eq "ubuntu") {
           Write-Host "Skipping readiness check for Ubuntu VM: $($vm.Name)" -ForegroundColor Yellow
           continue
        }

        $vmCreationJobs += Start-Job -ScriptBlock {
            param($vmName, $vmPath, $vhdPath, $finalVHD, $ipAddress, $credential)
            
            Write-Host "Creating VM: $vmName..." -ForegroundColor Yellow
            
            # Ensure the directory exists
            if (-Not (Test-Path -Path (Split-Path -Path $vhdPath -Parent))) {
                New-Item -Path (Split-Path -Path $vhdPath -Parent) -ItemType Directory -Verbose
            }
            
            # Copy the base VHD to the target location
            Copy-Item -Path $finalVHD -Destination $vhdPath -Force -Verbose
        
            # Determine memory based on VM name
            $startupMemory = if ($vmName -like "*DB*") { 16GB } else { 8GB }
            $minMemory = if ($vmName -like "*DB*") { 16GB } else { 8GB }
            $maxMemory = if ($vmName -like "*DB*") { 32GB } else { 16GB }

            # Create VM
            New-VM -Name $vmName -MemoryStartupBytes $startupMemory -VHDPath $vhdPath -Generation 1 -SwitchName "NestedSwitch" 
            Set-VM -Name $vmName -DynamicMemory -MemoryMinimumBytes $minMemory -MemoryMaximumBytes $maxMemory
            Set-VMProcessor $vmName -Count 4    
            
            # Start the VM
            Start-VM $vmName -Verbose
            
            # Wait for the VM to start and become responsive
            $totalWaitTime = 300  # Total wait time in seconds
            $intervalTime = 10    # Interval for status messages in seconds
            $elapsedTime = 0
            
            Write-Host "Waiting for VM to get ready..."
            
            while ($elapsedTime -lt $totalWaitTime) {
                Start-Sleep -Seconds $intervalTime
                $elapsedTime += $intervalTime
                $remainingTime = $totalWaitTime - $elapsedTime
                Write-Host "Still waiting... $elapsedTime seconds elapsed, $remainingTime seconds remaining" -ForegroundColor Yellow
                
                # Check if the VM is responsive
                try {
                    $vmState = Get-VM -Name $vmName | Select-Object -ExpandProperty State
                    if ($vmState -eq 'Running') {
                        $result = Invoke-Command -VMName $vmName -Credential $credential -ScriptBlock { Get-Service -Name 'WinRM' } -ErrorAction Stop
                        if ($result.Status -eq 'Running') {
                            Write-Host "VM $vmName is ready." -ForegroundColor Green
                            break
                        }
                    }
                }
                catch {
                    # VM is not yet responsive, continue waiting
                }
            }
            
            if ($elapsedTime -ge $totalWaitTime) {
                Write-Host "Timeout waiting for VM $vmName to be ready." -ForegroundColor Red
                return
            }
            
            # Set static IP and computer name inside the VM
            Invoke-Command -VMName $vmName -Credential $credential -ScriptBlock {
                param ($computerName, $ipAddress)
                $adapter = Get-NetAdapter -Name "Ethernet"
                If ($adapter) {
                    New-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway "172.100.2.1"
                    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "168.63.129.16"
                }
                else {
                    Write-Error "Network adapter 'Ethernet' not found."
                }
                Rename-Computer -NewName $computerName -Force -Restart
            } -ArgumentList $vmName, $ipAddress
        } -ArgumentList $vmName, $vmPath, $vhdPath, $finalVHD, $ipAddress, $credential
    }
}

# Wait for all VM creation jobs to complete
$vmCreationJobs | Wait-Job
$vmCreationJobs | Receive-Job
$vmCreationJobs | Remove-Job

# Wait for all Windows VMs to be ready
foreach ($config in $vmConfigs) {
    foreach ($vm in $config.VMs) {
        # Skip Ubuntu VMs
        if ($vm.SetId -eq "ubuntu") {
            Write-Host "Skipping readiness check for Ubuntu VM: $($vm.Name)" -ForegroundColor Yellow
            continue
        }

        $vmReady = Wait-ForVMReadiness -VMName $vm.Name
        if (-not $vmReady) {
            Write-Error "VM $($vm.Name) did not become ready in time. Exiting script."
            exit
        }
    }
}

# Configure VMs in stages
foreach ($config in $vmConfigs) {
    # Configure DB VMs first
    $dbVMs = $config.VMs | Where-Object { $_.Name -like "DB*" -and $_.SetId -ne "ubuntu" }
    foreach ($vm in $dbVMs) {
        Configure-DBVM -vm $vm -config $config -variables $jobVariables
    }
    
    # Then configure Web VMs
    $webVMs = $config.VMs | Where-Object { $_.Name -like "WEB*" -and $_.SetId -ne "ubuntu" }
    foreach ($vm in $webVMs) {
        Configure-WebVM -vm $vm -config $config -variables $jobVariables
        # The API call to create the schema is now handled within the Configure-WebVM function
    }
    
    # Finally, configure other VMs
    $otherVMs = $config.VMs | Where-Object { $_.Name -notlike "DB*" -and $_.Name -notlike "WEB*" -and $_.SetId -ne "ubuntu" }
    foreach ($vm in $otherVMs) {
        Configure-OtherVM -vm $vm -config $config -variables $jobVariables
    }
    
    $ubuntuVMs = $config.VMs | Where-Object { $_.SetId -eq "ubuntu" }
    foreach ($vm in $ubuntuVMs) {
        # Add any Ubuntu-specific configuration here
        Write-Host "Configuring Ubuntu VM: $($vm.Name)" -ForegroundColor Yellow
        Configure-OtherVM -vm $vm -config $config -variables $jobVariables
    }
}

Write-Host "All VMs have been created and configured." -ForegroundColor Green
$scriptEndTime = Get-Date
$scriptDuration = $scriptEndTime - $scriptStartTime
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "Script completed at: $scriptEndTime" -ForegroundColor Cyan
Write-Host "Total execution time: $($scriptDuration.ToString('hh\:mm\:ss'))" -ForegroundColor Cyan\
Stop-Transcript