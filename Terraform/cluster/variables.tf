variable "rg_name" {
  description = "Name of resource group"
  type = string
}

variable "rg_location" {
  description = "Resource group location"
  type = string
}

variable "cluster_name" {
  description = "Name of aks cluster"
  type = string
  default = "front-shop-aks"
}

variable "default_node_count" {
  description = "Count of default nodes"
  type = number
  default = 1
}

variable "spot_node_count" {
  description = "Count of spot nodes"
  type = number
  default = 1
}

variable "subnet_id" {
  description = "Id of network"
  type = string
}