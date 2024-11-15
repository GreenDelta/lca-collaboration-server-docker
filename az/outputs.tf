output "app_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.app_gateway.ip_address
}

output "elasticsearch_vm_private_ip" {
  value       = var.ELASTICSEARCH_ADMIN_USER != "" ? module.elasticsearch[0].private_ip : null
  description = "Private IP address of the Elasticsearch VM for internal network access."
  sensitive   = true
}

output "elasticsearch_vm_public_ip" {
  value       = var.ELASTICSEARCH_ADMIN_USER != "" ? module.elasticsearch[0].public_ip : null
  description = "Public IP address of the Elasticsearch VM"
  sensitive   = true
}
