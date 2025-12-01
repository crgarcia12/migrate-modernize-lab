variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_spaces" {
  description = "Address spaces for the virtual network"
  type        = list(string)
}

variable "location" {
  description = "Azure region for the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name           = string
    address_prefix = string
    nsg_name       = string
    private_ip     = string
  }))
}
