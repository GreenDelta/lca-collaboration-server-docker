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

variable "virtual_network_id" {
  description = "The ID of the virtual network."
  type = string
}

variable "address_prefix" {
  description = "The address space used by the subnet."
  type        = string
}

variable "root_user" {
  type        = string
  description = "MySQL root user name"
}

variable "root_password" {
  type        = string
  description = "MySQL root password"
  sensitive   = true
}

variable "server_name" {
  type        = string
  default     = "mysqlfs-lcacollab"
  description = "MySQL Flexible Server name"
}

variable "database" {
  type        = string
  default     = "collaboration-server"
  description = "MySQL database name for the LCA Collaboration Server"
}
