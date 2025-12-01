variable "name" {
  description = "Name of the public IP"
  type        = string
}

variable "location" {
  description = "Azure region for the public IP"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "allocation_method" {
  description = "Allocation method for the public IP"
  type        = string
  default     = "Static"
}
