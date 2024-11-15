variable "resource_group_name" {
  description = "The name of the resource group."
  type = string
}

variable "location" {
  description = "The location of the resources."
  type = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
  type = string
}

variable "address_prefix" {
  description = "The address space used by the subnet."
  type        = string
}

variable "app_address_prefix" {
  description = "The address space of the application connecting to Elasticsearch."
  type        = string
}

variable "admin_user" {
  description = "The admin user of the Elasticsearch VM."
  type        = string
}


