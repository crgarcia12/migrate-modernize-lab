variable "vm_name" {
  description = "VM name to use in NIC naming"
  type        = string
}

variable "location" {
  description = "Azure region for the NICs"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "primary_subnet_id" {
  description = "ID of the primary subnet"
  type        = string
}

variable "primary_private_ip" {
  description = "Private IP address for primary NIC"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the public IP to associate with primary NIC"
  type        = string
}

variable "secondary_subnet_id" {
  description = "ID of the secondary subnet"
  type        = string
}

variable "secondary_private_ip" {
  description = "Private IP address for secondary NIC"
  type        = string
}

variable "enable_accelerated_networking" {
  description = "Enable accelerated networking on secondary NIC"
  type        = bool
  default     = true
}
