output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = module.resource_group.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.virtual_network.vnet_name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.virtual_network.vnet_id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = module.windows_vm.vm_name
}

output "vm_id" {
  description = "ID of the virtual machine"
  value       = module.windows_vm.vm_id
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = module.public_ip.ip_address
}

output "primary_nic_private_ip" {
  description = "Primary NIC private IP address"
  value       = module.network_interface.primary_private_ip
}

output "secondary_nic_private_ip" {
  description = "Secondary NIC private IP address"
  value       = module.network_interface.secondary_private_ip
}
