output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.migration_environment.resource_group_name
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = module.migration_environment.vm_name
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = module.migration_environment.public_ip_address
}

output "primary_nic_private_ip" {
  description = "Primary NIC private IP address"
  value       = module.migration_environment.primary_nic_private_ip
}