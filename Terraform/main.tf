terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true 
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.rg_location
}

module "cluster" {
  source = "./cluster"
  rg_name = var.rg_name
  rg_location = var.rg_location
  depends_on = [ azurerm_resource_group.rg ]
}