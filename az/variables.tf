variable "SUBSCRIPTION_ID" {
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
