output "private_ip" {
  value       = azurerm_network_interface.this.ip_configuration[0].private_ip_address
  description = "Private IP address of the Elasticsearch VM for internal network access."
}

output "public_ip" {
  value       = azurerm_public_ip.this.ip_address
  description = "Public IP address of the Elasticsearch VM"
}
