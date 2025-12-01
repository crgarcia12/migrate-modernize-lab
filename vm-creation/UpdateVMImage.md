

# Azure Hyper-V Infrastructure

This Terraform configuration deploys a Windows Server 2022 virtual machine in Azure configured as a Hyper-V host, enabling nested virtualization with network connectivity between nested VMs and other Azure resources.

## Architecture Overview

The infrastructure includes:
- A Windows Server 2022 VM (Size: Standard_E16_v5) with Hyper-V role
- Dual network interfaces (primary with public IP, secondary with accelerated networking)
- Custom virtual network with multiple subnets
- Network security groups with customizable rules
- User-defined routing for nested VM connectivity
- Boot diagnostics with random storage account name
- Data disk (1024 GB) for VM storage
- Automated configuration using PowerShell DSC and Custom Script Extension

## Prerequisites

- Azure subscription
- Terraform installed (version 0.12 or later)
- Azure CLI installed and authenticated
- PowerShell DSC configuration file (`DSCInstallWindowsFeatures.ps1`)
- Hyper-V host setup script (`hvhostsetup.ps1`)

## Network Configuration

The deployment creates:
- Virtual network with custom address space
- Multiple subnets managed through local variables
- Network security groups with dynamic rule configuration
- User-defined routes for nested VM connectivity
- Public IP for remote access

## Security Features

- Random password generation for admin user
- Network security groups with customizable rules
- Private IP addresses statically assigned
- Boot diagnostics enabled
- Network isolation with subnet segmentation

## Deployment

1. Initialize Terraform:
```powershell
$env:TF_VAR_vmpassword = "YourSecurePasswordUsedToLoginToTheVM"
terraform init
```

2. Review the deployment plan:
```powershell
terraform plan
```

3. Apply the configuration:
```powershell
terraform apply
```

## Required Variables

The following variables need to be configured:

- `location`: Azure region for deployment
- `adminuser`: Administrator username
- `company_code`: (Optional) Three-letter company code for resource naming
- `instance_number`: (Optional) Instance number for resource naming (1-999)

## Local Variables

The following local variables are configured in the deployment:

- `rg_name`: Resource group name (format: "rg-{company_code}-hyperv-{location}-{instance}")
- `vnet_name`: Virtual network name (format: "vnet-{company_code}-hyperv-{location}-{instance}")
- `vm_name`: Virtual machine name
- `address_spaces`: VNet address space (default: ["172.100.0.0/17"])
- `subnets`: Subnet configurations
- `nsg_rules`: Network security group rules
- `DSCInstallWindowsFeaturesUri`: URI for DSC configuration
- `HVHostSetupScriptUri`: URI for Hyper-V setup script

## Example Configuration

Create a `terraform.tfvars` file with your values:

```hcl
location        = "westeurope"
adminuser       = "azureadmin"
company_code    = "xyz"      # Optional: Your three-letter company code
instance_number = 1          # Will generate "001" suffix
```

## Post-Deployment Configuration

The VM is automatically configured with:
1. Windows Server roles and features (via PowerShell DSC)
2. Hyper-V configuration (via Custom Script Extension)
3. Network configuration for nested VM connectivity

## Outputs

- `admin_password`: Generated administrator password (sensitive value)

## Network Architecture

The deployment creates two network interfaces:
1. Primary NIC:
   - Connected to NAT subnet
   - Public IP attached
   - Static private IP: 172.100.0.4

2. Secondary NIC:
   - Connected to Hyper-V subnet
   - Accelerated networking enabled
   - Static private IP: 172.100.1.4

## Custom Address Space

If you want to use a different address space, modify the `address_spaces` local variable in your configuration:

```hcl
locals {
  address_spaces = ["10.0.0.0/16"]  # Example of custom address space
}
```

## Troubleshooting

If deployment fails:
1. Check the boot diagnostics logs in the storage account
2. Review the Custom Script Extension logs
3. Verify network connectivity and NSG rules
4. Ensure PowerShell DSC and setup scripts are accessible

## Clean Up

To remove all resources:
```bash
terraform destroy
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request