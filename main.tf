provider "aws" {
  version = "=5.27"
  region = "eu-central-1"
  
}


module "network" {
  source = "./network"
  environment = var.environment
}

module "storage" {
  source = "./storage"
  environment = var.environment
}