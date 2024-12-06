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

variable "SSL_CERT_FILE" {
  type        = string
  description = "Path to the SSL certificate file"
}

variable "SSL_CERT_PASSWORD" {
  type        = string
  description = "Password for the SSL certificate file"
  sensitive   = true
}

variable "lcacollab_version" {
  type        = string
  default     = "2.3"
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

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "Location of the resources"
}

variable "address_space" {
  type    = string
  default = "10.0.0.0/24"
}

variable "public_address_prefix" {
  type    = string
  default = "10.0.0.16/28"
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
