variable "name" {
  description = "Name of the route table"
  type        = string
}

variable "location" {
  description = "Azure region for the route table"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "route_name" {
  description = "Name of the route"
  type        = string
}

variable "route_address_prefix" {
  description = "Address prefix for the route"
  type        = string
}

variable "next_hop_type" {
  description = "Next hop type for the route"
  type        = string
}

variable "next_hop_ip_address" {
  description = "Next hop IP address for the route"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to associate with the route table"
  type        = string
}
