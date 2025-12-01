resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.network_interface_ids
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  os_disk {
    name                 = "${var.vm_name}-os"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }
}

resource "azurerm_managed_disk" "data_disk" {
  name                 = "${var.vm_name}-disk1"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "0"
  caching            = var.data_disk_caching
}

resource "azurerm_virtual_machine_extension" "dsc_extension" {
  name                       = "InstallWindowsFeatures"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.77"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
  {
    "wmfVersion": "latest",
    "configuration": {
      "url": "${var.dsc_config_url}",
      "script": "DSCInstallWindowsFeatures.ps1",
      "function": "InstallWindowsFeatures"
    }
  }
  SETTINGS
}

resource "azurerm_virtual_machine_extension" "custom_script" {
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.data_disk_attach,
    azurerm_virtual_machine_extension.dsc_extension
  ]
  name                 = "${var.vm_name}-vmext-hyperv"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  
  settings = jsonencode({
    "fileUris": [
      var.custom_script_url
    ],
    "commandToExecute": var.custom_script_command
  })

  timeouts {
    create = "2h30m"
    delete = "1h"
  }
}
