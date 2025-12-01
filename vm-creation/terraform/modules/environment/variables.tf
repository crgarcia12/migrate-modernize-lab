variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, test, prod)"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "swedencentral"
}

variable "vm_size" {
  description = "Size of the Host Virtual Machine"
  type        = string
  default     = "Standard_E32as_v5"
  
  validation {
    condition     = contains(["Standard_E32as_v5"], var.vm_size)
    error_message = "Invalid VM size selected"
  }
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "artifacts_location" {
  description = "The base URI where artifacts required by this template are located including a trailing '/'"
  type        = string
  default     = "https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/main/vm-creation-infra"
}
