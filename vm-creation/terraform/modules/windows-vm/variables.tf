variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "location" {
  description = "Azure region for the VM"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "network_interface_ids" {
  description = "List of network interface IDs"
  type        = list(string)
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "os_disk_caching" {
  description = "OS disk caching type"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "OS disk storage account type"
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "2022-datacenter-g2"
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

variable "boot_diagnostics_storage_uri" {
  description = "Storage URI for boot diagnostics"
  type        = string
}

variable "data_disk_storage_account_type" {
  description = "Data disk storage account type"
  type        = string
  default     = "Standard_LRS"
}

variable "data_disk_size_gb" {
  description = "Size of the data disk in GB"
  type        = number
  default     = 1024
}

variable "data_disk_caching" {
  description = "Data disk caching type"
  type        = string
  default     = "ReadOnly"
}

variable "dsc_config_url" {
  description = "URL to DSC configuration"
  type        = string
}

variable "custom_script_url" {
  description = "URL to custom script"
  type        = string
}

variable "custom_script_command" {
  description = "Command to execute custom script"
  type        = string
}
