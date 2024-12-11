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

variable "public_address_prefix" {
  type    = string
  default = "10.0.0.16/28"
}

variable "SSL_CERT_FILE" {
  type        = string
  description = "Path to the SSL certificate file"
  default     = "/home/francois/code/cs/lca-collaboration-server-docker/az/certificate.pfx"
}

variable "SSL_CERT_PASSWORD" {
  type        = string
  description = "Password for the SSL certificate file"
  sensitive   = true
  default     = "Plea5eCh@ngeMe"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "app_private_ip" {
  type        = string
  description = "Private IP address of LCA Collaboration Server app"
}
