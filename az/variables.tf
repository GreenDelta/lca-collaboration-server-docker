variable "AZURE_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure Subscription ID"
  sensitive   = true
}

variable "MYSQL_ROOT_USER" {
  type        = string
  description = "MySQL root user name"
}

variable "MYSQL_ROOT_PASSWORD" {
  type        = string
  description = "MySQL root password"
  sensitive   = true
}

variable "ELASTICSEARCH_ADMIN_USER" {
  type        = string
  description = "OpenSearch VM admin user name"
  sensitive   = true
}

variable "mysql_server_name" {
  type        = string
  default     = "mysqlfs-lcacollab"
  description = "MySQL Flexible Server name"
}

variable "mysql_database" {
  type        = string
  default     = "collaboration-server"
  description = "MySQL database name for the LCA Collaboration Server"
}

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "Location of the resources"
}

variable "address_space" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_address_prefix" {
  type    = string
  default = "10.0.1.0/24"
}

variable "app_address_prefix" {
  type    = string
  default = "10.0.2.0/24"
}

variable "mysql_address_prefix" {
  type    = string
  default = "10.0.3.0/24"
}

variable "elasticsearch_address_prefix" {
  type    = string
  default = "10.0.4.0/24"
}
