provider "aws" {
  version = "~>5.0"
  region = "eu-central-1"
  assume_role {
    role_arn = "arn:aws:iam::099036503771:role/terraformrole"
    external_id = "terraformmain"
    
  }
}

module "network" {
  source = "./network"
  environment = var.environment
  s3_domain_name = module.storage.bucket_domain_name
}

module "storage" {
  source = "./storage"
  environment = var.environment
}

module "cluster" {
  source = "./ecs_cluster"
  environment = var.environment
  subnet_name = module.network.private_sub_name
  asgroup_arn = module.as_group.asgroup_arn
  # security_group_name = 
}

module "as_group" {
  source = "./autoscalling"
  environment = var.environment
  subnet_name = module.network.private_sub_name
  private_id = module.network.private_sub
  public_id = module.network.public_sub
  cluster_name = module.cluster.cluste_name
  vpc_id = module.network.vpc_id
}