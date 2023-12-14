provider "aws" {
  version = "=5.27"
  region = "eu-central-1"
  
}


module "network" {
  source = "./network"
}