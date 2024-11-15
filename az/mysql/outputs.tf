output "url" {
  description = "URL of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.this.fqdn
}
