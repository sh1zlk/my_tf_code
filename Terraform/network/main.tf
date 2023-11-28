resource "azurerm_network_security_group" "security_group" {
  name                = "front-shop-security-group"
  location            = var.rg_location
  resource_group_name = var.rg_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "front-shop-network"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.security_group.id
  }
}