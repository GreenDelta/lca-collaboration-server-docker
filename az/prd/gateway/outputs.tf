output "fqdn" {
  description = "FQDN of the LCA Collaboration Server"
  value       = azurerm_public_ip.app_gateway.fqdn
}
