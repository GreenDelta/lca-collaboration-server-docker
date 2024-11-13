output "app_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.app_gateway.ip_address
}

output "elasticsearch_vm_private_ip" {
  value       = azurerm_network_interface.elasticsearch.ip_configuration[0].private_ip_address
  description = "Private IP address of the ElasticSearch VM for internal network access."
}

output "elasticsearch_vm_public_ip" {
  value       = azurerm_public_ip.elasticsearch.ip_address
  description = "Public IP address of the ElasticSearch VM"
}
