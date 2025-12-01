resource "azurerm_network_interface" "nic_primary" {
  name                = "${var.vm_name}-nic-primary"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-ipconfig"
    subnet_id                     = var.primary_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.primary_private_ip
    public_ip_address_id          = var.public_ip_id
  }
}

resource "azurerm_network_interface" "nic_secondary" {
  name                = "${var.vm_name}-nic-secondary"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-ipconfig"
    subnet_id                     = var.secondary_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.secondary_private_ip
  }
  
  accelerated_networking_enabled = var.enable_accelerated_networking
}
