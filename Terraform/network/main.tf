resource "azurerm_network_security_group" "security_group" {
  name                = "front-shop-security-group"
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "front-shop-network"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

}

resource "azurerm_subnet" "subnet1" {
  name = "subnet1"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.1.0/24"]

}


output "subnet_id" {
  value = azurerm_subnet.subnet1.id
}