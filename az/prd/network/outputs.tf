output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.lcacollab.name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.lcacollab.id
}

output "app_subnet_id" {
  description = "ID of the app subnet"
  value       = azurerm_subnet.app.id
}

output "storage_subnet_id" {
  description = "ID of the storage subnet"
  value       = azurerm_subnet.storage.id
}

output "mysql_subnet_id" {
  description = "ID of the MySQL subnet"
  value       = azurerm_subnet.mysql.id
}
