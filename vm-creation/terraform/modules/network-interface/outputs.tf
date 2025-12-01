output "primary_nic_id" {
  description = "ID of the primary network interface"
  value       = azurerm_network_interface.nic_primary.id
}

output "secondary_nic_id" {
  description = "ID of the secondary network interface"
  value       = azurerm_network_interface.nic_secondary.id
}

output "primary_private_ip" {
  description = "Private IP address of the primary NIC"
  value       = azurerm_network_interface.nic_primary.private_ip_address
}

output "secondary_private_ip" {
  description = "Private IP address of the secondary NIC"
  value       = azurerm_network_interface.nic_secondary.private_ip_address
}
