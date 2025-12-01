output "id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.storage.id
}

output "name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}
