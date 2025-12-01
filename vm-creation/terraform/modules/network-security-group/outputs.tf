output "nsg_ids" {
  description = "Map of NSG names to IDs"
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.id }
}

output "nsgs" {
  description = "Map of NSG resources"
  value       = azurerm_network_security_group.nsgs
}
