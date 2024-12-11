variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "rg-LCACollab-network-prd-weu"
}

variable "location" {
  type        = string
  description = "Location of the resources"
  default     = "westeurope"
}

variable "address_space" {
  type    = string
  default = "10.0.0.0/24"
}

variable "app_address_prefix" {
  type    = string
  default = "10.0.0.32/28"
}

variable "storage_address_prefix" {
  type    = string
  default = "10.0.0.48/28"
}

variable "mysql_address_prefix" {
  type    = string
  default = "10.0.0.64/28"
}

variable "elasticsearch_address_prefix" {
  type    = string
  default = "10.0.0.80/28"
}

variable "with_elasticsearch" {
  type = bool
  default = false
}
