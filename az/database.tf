resource "azurerm_subnet" "mysql" {
  address_prefixes     = [var.mysql_address_prefix]
  name                 = "snet-mysql"
  resource_group_name  = azurerm_resource_group.lcacollab.name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "mysql" {
  name                = "${azurerm_resource_group.lcacollab.name}.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.lcacollab.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "vnetzone-mysql-${azurerm_resource_group.lcacollab.name}.com"
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  resource_group_name   = azurerm_resource_group.lcacollab.name
  virtual_network_id    = azurerm_virtual_network.lcacollab.id
}

resource "azurerm_mysql_flexible_server" "lcacollab" {
  location                     = azurerm_resource_group.lcacollab.location
  name                         = "mysqlfs-lcacollab"
  zone                         = "1"
  resource_group_name          = azurerm_resource_group.lcacollab.name
  administrator_login          = var.MYSQL_ROOT_USER
  administrator_password       = var.MYSQL_ROOT_PASSWORD
  backup_retention_days        = 7
  delegated_subnet_id          = azurerm_subnet.mysql.id
  geo_redundant_backup_enabled = false
  sku_name                     = "B_Standard_B1ms"
  version                      = "8.0.21"

  storage {
    iops    = 360
    size_gb = 20
  }
}

resource "azurerm_mysql_flexible_database" "lcacollab" {
  name                = var.mysql_database
  resource_group_name = azurerm_resource_group.lcacollab.name
  server_name         = azurerm_mysql_flexible_server.lcacollab.name
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"
}
