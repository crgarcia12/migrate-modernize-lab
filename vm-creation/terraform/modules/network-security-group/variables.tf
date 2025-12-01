variable "vm_name" {
  description = "VM name to use in NSG naming"
  type        = string
}

variable "location" {
  description = "Azure region for the NSGs"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    name           = string
    address_prefix = string
    nsg_name       = string
    private_ip     = string
  }))
}

variable "subnet_ids" {
  description = "Map of subnet names to IDs"
  type        = map(string)
}

variable "nsg_rules" {
  description = "Map of NSG names to security rules"
  type = map(list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  })))
}
