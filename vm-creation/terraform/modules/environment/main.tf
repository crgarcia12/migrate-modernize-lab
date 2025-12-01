locals {
  # Resource naming based on prefix and environment
  rg_name         = "${var.prefix}-${var.environment}-rg"
  vnet_name       = "${var.prefix}-${var.environment}-vnet"
  vm_name         = "${var.prefix}-${var.environment}-vm"
  storage_name    = replace("${var.prefix}${var.environment}diag", "-", "")
  public_ip_name  = "${var.prefix}-${var.environment}-ip"
  route_table_name = "${var.prefix}-${var.environment}-udr-azurevms"
  
  address_spaces = ["172.100.0.0/17"]
  
  subnets = [
    { name = "${var.prefix}-${var.environment}-nat", address_prefix = "172.100.0.0/24", nsg_name = "${var.prefix}-${var.environment}-nat-nsg", private_ip = "172.100.0.4" },
    { name = "${var.prefix}-${var.environment}-hypervlan", address_prefix = "172.100.1.0/24", nsg_name = "${var.prefix}-${var.environment}-hyperv-nsg", private_ip = "172.100.1.4" },
    { name = "${var.prefix}-${var.environment}-ghosted", address_prefix = "172.100.2.0/24", nsg_name = "${var.prefix}-${var.environment}-ghosted-nsg", private_ip = "" },
    { name = "${var.prefix}-${var.environment}-azurevms", address_prefix = "172.100.3.0/24", nsg_name = "${var.prefix}-${var.environment}-azurevms-nsg", private_ip = "" }
  ]

  ghosted_subnet_address_prefix = local.subnets[2].address_prefix

  nsg_rules = {
    "${var.prefix}-${var.environment}-nat-nsg" = [
      {
        name                       = "RDP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "172.100.0.4"
      }
    ]
    "${var.prefix}-${var.environment}-hyperv-nsg" = [
      {
        name                       = "RDP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "172.100.1.4"
      }
    ]
    "${var.prefix}-${var.environment}-ghosted-nsg"  = []
    "${var.prefix}-${var.environment}-azurevms-nsg" = []
  }

  DSCInstallWindowsFeaturesUri = "${var.artifacts_location}scripts/dscinstallwindowsfeatures.zip"
  HVHostSetupScriptUri         = "${var.artifacts_location}scripts/hvhostsetup.ps1"
}

# Resource Group Module
module "resource_group" {
  source   = "../resource-group"
  name     = local.rg_name
  location = var.location
}

# Virtual Network Module
module "virtual_network" {
  source              = "../virtual-network"
  vnet_name           = local.vnet_name
  address_spaces      = local.address_spaces
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  subnets             = local.subnets
}

# Public IP Module
module "public_ip" {
  source              = "../public-ip"
  name                = local.public_ip_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
}

# Network Security Group Module
module "network_security_group" {
  source              = "../network-security-group"
  vm_name             = ""  # Not used since NSG names come from subnets
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  subnets             = local.subnets
  subnet_ids          = module.virtual_network.subnet_ids
  nsg_rules           = local.nsg_rules
}

# Network Interface Module
module "network_interface" {
  source                        = "../network-interface"
  vm_name                       = local.vm_name
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  primary_subnet_id             = module.virtual_network.subnet_ids["${var.prefix}-${var.environment}-nat"]
  primary_private_ip            = "172.100.0.4"
  public_ip_id                  = module.public_ip.id
  secondary_subnet_id           = module.virtual_network.subnet_ids["${var.prefix}-${var.environment}-hypervlan"]
  secondary_private_ip          = "172.100.1.4"
  enable_accelerated_networking = true
}

# Route Table Module
module "route_table" {
  source               = "../route-table"
  name                 = local.route_table_name
  location             = module.resource_group.location
  resource_group_name  = module.resource_group.name
  route_name           = "Nested-VMs"
  route_address_prefix = local.ghosted_subnet_address_prefix
  next_hop_type        = "VirtualAppliance"
  next_hop_ip_address  = module.network_interface.secondary_private_ip
  subnet_id            = module.virtual_network.subnet_ids["${var.prefix}-${var.environment}-azurevms"]
}

# Storage Account Module
module "storage_account" {
  source                   = "../storage-account"
  name                     = local.storage_name
  location                 = module.resource_group.location
  resource_group_name      = module.resource_group.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Windows VM Module
module "windows_vm" {
  source                         = "../windows-vm"
  vm_name                        = local.vm_name
  location                       = module.resource_group.location
  resource_group_name            = module.resource_group.name
  network_interface_ids          = [module.network_interface.primary_nic_id, module.network_interface.secondary_nic_id]
  vm_size                        = var.vm_size
  admin_username                 = var.admin_username
  admin_password                 = var.admin_password
  boot_diagnostics_storage_uri   = module.storage_account.primary_blob_endpoint
  dsc_config_url                 = local.DSCInstallWindowsFeaturesUri
  custom_script_url              = local.HVHostSetupScriptUri
  custom_script_command          = "powershell -ExecutionPolicy Unrestricted -File hvhostsetup.ps1 -NIC1IPAddress ${module.network_interface.primary_private_ip} -NIC2IPAddress ${module.network_interface.secondary_private_ip} -GhostedSubnetPrefix ${local.ghosted_subnet_address_prefix} -VirtualNetworkPrefix ${local.address_spaces[0]}"
}
