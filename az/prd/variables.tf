variable "mysql_root_user" {
  type        = string
  description = "MySQL root user name"
}

variable "mysql_root_password" {
  type        = string
  description = "MySQL root password"
  sensitive   = true
}

variable "elasticsearch_admin_user" {
  type        = string
  description = "OpenSearch VM admin user name"
  sensitive   = true
}

variable "lcacollab_version" {
  type        = string
  default     = "2.4.0"
  description = "LCA Collaboration Server version"
}

variable "mysql_server_name" {
  type        = string
  default     = "mysqlfs-lcacollab"
  description = "MySQL Flexible Server name"
}

variable "mysql_database" {
  type        = string
  default     = "lcacollab"
  description = "MySQL database name for the LCA Collaboration Server"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "rg-LCACollab-prd-weu"
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

variable "storage_address_prefix" {
  type    = string
  default = "10.0.0.32/28"
}

variable "app_address_prefix" {
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
