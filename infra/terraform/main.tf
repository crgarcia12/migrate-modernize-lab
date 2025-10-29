resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "hypervnetwork" {
  name                = local.vnet_name
  address_space       = local.address_spaces
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet" "subnets" {
  for_each             = { for subnet in local.subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hypervnetwork.name
  address_prefixes     = [each.value.address_prefix]
}


# Create public IPs
resource "azurerm_public_ip" "hypervpublicip" {
  name                = "${local.vm_name}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsgs" {
  for_each            = { for subnet in local.subnets : subnet.nsg_name => subnet }
  name                = "${local.vm_name}-${each.value.nsg_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = lookup(local.nsg_rules, each.value.nsg_name, [])
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# Create network interface
resource "azurerm_network_interface" "hypervnicprimary" {
  name                = "${local.vm_name}-nic-primary"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${local.vm_name}-ipconfig"
    subnet_id                     = azurerm_subnet.subnets["nat"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.100.0.4"
    public_ip_address_id          = azurerm_public_ip.hypervpublicip.id
  }
}

# Create network interface
resource "azurerm_network_interface" "hypervnicsecondary" {
  name                = "${local.vm_name}-nic-secondary"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${local.vm_name}-ipconfig"
    subnet_id                     = azurerm_subnet.subnets["hypervlan"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.100.1.4"
  }
  accelerated_networking_enabled = true
}

# Connect the security group to the subnet

resource "azurerm_subnet_network_security_group_association" "associations" {
  for_each                  = { for subnet in local.subnets : subnet.name => subnet }
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.value.nsg_name].id
}

resource "azurerm_route_table" "udr" {
  name                = "udr-${local.vnet_name}-azurevms"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "Nested-VMs"
    address_prefix         = local.ghosted_subnet_address_prefix
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.hypervnicsecondary.private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "azurevms_association" {
  subnet_id      = azurerm_subnet.subnets["azurevms"].id
  route_table_id = azurerm_route_table.udr.id
}


# Create storage account for boot diagnostics
resource "azurerm_storage_account" "diagstorage" {
  name                     = replace("${local.prefix}-diag", "-", "")
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "hypervvm" {
  name                  = "${local.vm_name}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.hypervnicprimary.id, azurerm_network_interface.hypervnicsecondary.id]
  size                  = var.hostvmsize
  admin_username        = "adminuser"
  admin_password        = var.vmpassword

  os_disk {
    name                 = "${local.vm_name}-os"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  secure_boot_enabled = true
  vtpm_enabled        = true

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diagstorage.primary_blob_endpoint
  }
}

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${local.vm_name}-disk1"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1024
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadiskattach" {
  managed_disk_id    = azurerm_managed_disk.datadisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.hypervvm.id
  lun                = "0"
  caching            = "ReadOnly"
}


resource "azurerm_virtual_machine_extension" "vmExtension" {
  name                       = "InstallWindowsFeatures"
  virtual_machine_id         = azurerm_windows_virtual_machine.hypervvm.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.77"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
  {
    "wmfVersion": "latest",
    "configuration": {
      "url": "${local.DSCInstallWindowsFeaturesUri}",
      "script": "DSCInstallWindowsFeatures.ps1",
      "function": "InstallWindowsFeatures"
    }
  }
  SETTINGS
}

resource "azurerm_virtual_machine_extension" "hypervvmext" {
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.datadiskattach,
    azurerm_virtual_machine_extension.vmExtension
  ]
  name                 = "${local.vm_name}-vmext-hyperv"
  virtual_machine_id   = azurerm_windows_virtual_machine.hypervvm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  
  settings = jsonencode({
    "fileUris": [
      local.HVHostSetupScriptUri
    ],
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File hvhostsetup.ps1 -NIC1IPAddress ${azurerm_network_interface.hypervnicprimary.private_ip_address} -NIC2IPAddress ${azurerm_network_interface.hypervnicsecondary.private_ip_address} -GhostedSubnetPrefix ${local.ghosted_subnet_address_prefix} -VirtualNetworkPrefix ${local.address_spaces[0]}"
  })

  timeouts {
    create = "2h30m"
    delete = "1h"
  }
}