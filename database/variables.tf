variable "rg_name" {
  description = "Name of resource group"
  type = string
}

variable "rg_location" {
  description = "Resource group location"
  type = string
}

variable "adm_login" {
  description = "Login to MYSQL Server"
  type = string
  default = "frontshopadmin"
}

variable "subnet_id" {
  description = "Id of subnet"
  type = string
}