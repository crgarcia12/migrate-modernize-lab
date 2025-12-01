output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_windows_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_windows_virtual_machine.vm.name
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_windows_virtual_machine.vm.private_ip_address
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_windows_virtual_machine.vm.public_ip_address
}
