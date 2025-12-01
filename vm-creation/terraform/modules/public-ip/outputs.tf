output "id" {
  description = "ID of the public IP"
  value       = azurerm_public_ip.public_ip.id
}

output "ip_address" {
  description = "The IP address value that was allocated"
  value       = azurerm_public_ip.public_ip.ip_address
}
