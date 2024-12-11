resource "azurerm_mysql_flexible_server" "this" {
  location                     = var.location
  name                         = "mysqlfs-lcacollab-prd-weu"
  zone                         = 2
  resource_group_name          = var.resource_group_name
  administrator_login          = var.root_user
  administrator_password       = var.root_password
  backup_retention_days        = 7
  delegated_subnet_id          = var.subnet_id
  geo_redundant_backup_enabled = false
  sku_name                     = "B_Standard_B1ms"
  version                      = "8.0.21"

  storage {
    iops    = 360
    size_gb = 20
  }
}

resource "azurerm_mysql_flexible_database" "this" {
  name                = var.database
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"
}
