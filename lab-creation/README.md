# Azure Migrate Demo Infrastructure

This folder contains infrastructure-as-code templates for deploying a comprehensive Azure Migrate demo environment that simulates an on-premises environment and Azure migration scenarios.

## Quick Start

To deploy the lab to Azure:

1. Navigate to the `lab-creation` folder
2. Run the deployment script:

```powershell
.\New-MicroHackEnvironment.ps1
```

## Overview

The infrastructure consists of different components

1. **ARM/Bicep Templates** (`templates/` and `bicep/`) - Complete Azure migration environment including:
   - Virtual networks and subnets
   - Windows VM that simulates on-premises servers
   - Azure Migrate project for assessment and discovery

2. **Terraform Infrastructure** (`../vm-creation-infra/terraform/`) - Host environment creation for:
   - Multiple VM environments (mm1, mm3)
   - Hyper-V host infrastructure
   - Development and testing environments

3. **PowerShell Scripts** - Automation for:
   - Azure Migrate project configuration
   - Application deployment (Contoso Hotel)
   - VM setup and software installation

## Resources Created

### ARM Template (`templates/lab197959-template2 (v6).json`)

The ARM template deploys a complete Azure Migrate environment including:

#### Network Resources
- **Virtual Network** (`{prefix}-vnet`) with address space 172.100.0.0/17
- **Subnets**:
  - `nat` - 172.100.0.0/24 (NAT subnet with private IP 172.100.0.4)
  - `hypervlan` - 172.100.1.0/24 (Hyper-V LAN with private IP 172.100.1.4)
  - `ghosted` - 172.100.2.0/24 (Ghosted subnet)
  - `azurevms` - 172.100.3.0/24 (Azure VMs subnet)
- **Network Security Groups** (NSGs) for each subnet with RDP access rules
- **Public IP Address** for VM access
- **Route Table** for Azure VMs subnet
- **Network Interfaces** (primary and secondary for the VM)

#### Compute Resources
- **Windows Virtual Machine** (`{prefix}-vm`) with:
  - Standard DS2_v2 or configurable size
  - Windows Server 2019 or 2022
  - Admin credentials
  - Custom script extension for configuration

#### Storage Resources
- **Storage Account** for VM diagnostics and boot diagnostics

#### Azure Migrate Resources
- **Azure Migrate Project** with assessment and discovery capabilities
- **Azure Migrate Solutions** for server assessment and discovery

### Bicep Templates (`bicep/`)

The Bicep deployment creates the same resources as the ARM template but in a modular approach:

#### Main Resources (`main.bicep`)
- Virtual Network with 4 subnets
- Network Security Groups for each subnet
- Public IP address
- Storage account for diagnostics
- Route table for VM routing
- Two network interfaces (primary and secondary)
- Windows VM with Hyper-V role
- Azure Migrate project

#### Modular Components (`modules/`)
- `azure-migrate.bicep` - Azure Migrate project and solutions
- `network-interface.bicep` - Network interface configurations
- `network-security-group.bicep` - NSG rules and configurations
- `public-ip.bicep` - Public IP address settings
- `route-table.bicep` - Custom routing configurations
- `storage-account.bicep` - Storage account for diagnostics
- `virtual-network.bicep` - VNet and subnet configurations
- `windows-vm.bicep` - Windows VM with Hyper-V capabilities

### Terraform (`../vm-creation-infra/terraform/`)

The Terraform configuration creates VM host environments:

#### Resources Created per Environment
- **Resource Group** (`{prefix}-{environment}-rg`)
- **Virtual Network** (`{prefix}-{environment}-vnet`) with address space 172.100.0.0/17
- **Subnets** (4 subnets with same configuration as ARM/Bicep)
- **Network Security Groups** with RDP access rules
- **Public IP Address** (`{prefix}-{environment}-ip`)
- **Storage Account** for diagnostics (name: `{prefix}{environment}diag`)
- **Route Table** (`{prefix}-{environment}-udr-azurevms`)
- **Network Interfaces**
- **Windows Virtual Machine** (`{prefix}-{environment}-vm`)

#### Default Environments
- **mm1** - Migration environment 1
- **mm3** - Migration environment 3

### PowerShell Scripts

#### `New-MicroHackEnvironment.ps1`
Configuration script that:
- Imports Azure PowerShell modules
- Configures Azure Migrate project
- Creates server assessments
- Simulates on-premises server discovery
- Sets up migration scenarios
- Handles authentication and logging

#### `download-and-configure.ps1`
Wrapper script that:
- Downloads the latest New-MicroHackEnvironment.ps1 from GitHub
- Executes the configuration script non-interactively
- Handles logging to Azure Blob Storage

#### `setup.ps1` (`../vm-creation-infra/setup.ps1`)
VM setup script that:
- Installs SQL Server modules and dependencies
- Configures IIS and .NET Framework features
- Deploys Contoso Hotel application
- Sets up Python environment and ODBC drivers
- Configures database connections

## How to Run the Scripts

### Prerequisites

1. **Azure Subscription** with appropriate permissions
2. **Azure CLI** or **Azure PowerShell** installed
3. **Terraform** (for Terraform deployments)
4. **Git** (to clone the repository)

### Option 1: ARM Template Deployment

#### Using Azure CLI
```bash
az login
az account set --subscription "your-subscription-id"

# Create resource group
az group create --name "your-resource-group" --location "swedencentral"

# Deploy template
az deployment group create \
  --resource-group "your-resource-group" \
  --template-file "templates/lab197959-template2 (v6).json" \
  --parameters prefix="your-prefix"
```

#### Using Azure PowerShell
```powershell
Connect-AzAccount
Set-AzContext -SubscriptionId "your-subscription-id"

# Create resource group
New-AzResourceGroup -Name "your-resource-group" -Location "swedencentral"

# Deploy template
New-AzResourceGroupDeployment `
  -ResourceGroupName "your-resource-group" `
  -TemplateFile "templates/lab197959-template2 (v6).json" `
  -prefix "your-prefix"
```

### Option 2: Bicep Deployment

#### Using the Deploy Script
```powershell
# Navigate to bicep directory
cd lab-creation/bicep

# Run deployment script
./deploy.ps1 `
  -SubscriptionId "your-subscription-id" `
  -VmPassword (ConvertTo-SecureString "YourStrongPassword123!" -AsPlainText -Force) `
  -Location "swedencentral" `
  -ResourceGroupName "your-resource-group"
```

#### Manual Bicep Deployment
```bash
# Login and set subscription
az login
az account set --subscription "your-subscription-id"

# Create resource group
az group create --name "your-resource-group" --location "swedencentral"

# Deploy Bicep template
az deployment group create \
  --resource-group "your-resource-group" \
  --template-file "main.bicep" \
  --parameters prefix="your-prefix" \
  --parameters main.bicepparam
```

### Option 3: Terraform Deployment

```bash
# Navigate to terraform directory
cd vm-creation-infra/terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var="location=swedencentral" -var="vmpassword=YourStrongPassword123!"

# Apply deployment
terraform apply -var="location=swedencentral" -var="vmpassword=YourStrongPassword123!"
```

### Configuration Scripts

#### Run Azure Migrate Configuration
```powershell
# Option 1: Download and run automatically
./download-and-configure.ps1

# Option 2: Run configuration directly
./New-MicroHackEnvironment.ps1
```

#### VM Setup (for Terraform-created VMs)
```powershell
# Connect to the created VM and run:
cd vm-creation-infra
./setup.ps1
```

## Important Notes

1. **Resource Naming**: All resources use a prefix to avoid naming conflicts. Choose a unique prefix for your deployment.

2. **Passwords**: Ensure you use strong passwords that meet Azure security requirements (8+ characters, uppercase, lowercase, numbers, special characters).

3. **Permissions**: Your Azure account needs Contributor permissions on the subscription or resource group.

4. **Costs**: These deployments create billable Azure resources. Remember to clean up resources when done.

5. **Regions**: Default region is Sweden Central. Ensure the region supports all required services.

## Cleanup

To remove all resources:

```bash
# Delete resource group (removes all resources)
az group delete --name "your-resource-group" --yes --no-wait
```

Or for Terraform:
```bash
terraform destroy -var="location=swedencentral" -var="vmpassword=YourStrongPassword123!"
```

