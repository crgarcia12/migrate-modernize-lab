resource "azurerm_network_security_group" "nsgs" {
  for_each            = { for subnet in var.subnets : subnet.nsg_name => subnet }
  name                = var.vm_name != "" ? "${var.vm_name}-${each.value.nsg_name}" : each.value.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = lookup(var.nsg_rules, each.value.nsg_name, [])
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "associations" {
  for_each                  = { for subnet in var.subnets : subnet.name => subnet }
  subnet_id                 = var.subnet_ids[each.key]
  network_security_group_id = azurerm_network_security_group.nsgs[each.value.nsg_name].id
}
