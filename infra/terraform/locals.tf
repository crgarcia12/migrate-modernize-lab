locals {
  prefix = "crgar-mig"
  
  vnet_name      = "${local.prefix}-vnet"
  address_spaces = ["172.100.0.0/17"]       
  vm_name         = "${local.prefix}-vm"
  rg_name         = "${local.prefix}-rg"
  subnets = [
    { name = "nat", address_prefix = "172.100.0.0/24", nsg_name = "nat-nsg", private_ip = "172.100.0.4" },
    { name = "hypervlan", address_prefix = "172.100.1.0/24", nsg_name = "hyperv-nsg", private_ip = "172.100.1.4" },
    { name = "ghosted", address_prefix = "172.100.2.0/24", nsg_name = "ghosted-nsg", private_ip = "" },
    { name = "azurevms", address_prefix = "172.100.3.0/24", nsg_name = "azurevms-nsg", private_ip = "" }
  ]

  ghosted_subnet_address_prefix = local.subnets[2].address_prefix

  nsg_rules = {
    "nat-nsg" = [
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
    "hyperv-nsg" = [
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
    "ghosted-nsg" = []
    "azurevms-nsg" = []
  }

  # DSCInstallWindowsFeaturesUri = "${var._artifactsLocation}dscinstallwindowsfeatures.zip${var._artifactsLocationSasToken}"
  # HVHostSetupScriptUri    = "${var._artifactsLocation}hvhostsetup.ps1${var._artifactsLocationSasToken}"

  DSCInstallWindowsFeaturesUri = "${var.artifacts_location}scripts/dscinstallwindowsfeatures.zip"
  HVHostSetupScriptUri         = "${var.artifacts_location}scripts/hvhostsetup.ps1"

}