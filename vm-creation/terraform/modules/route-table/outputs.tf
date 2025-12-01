output "id" {
  description = "ID of the route table"
  value       = azurerm_route_table.udr.id
}

output "name" {
  description = "Name of the route table"
  value       = azurerm_route_table.udr.name
}
