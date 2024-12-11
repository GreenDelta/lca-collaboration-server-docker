resource "azurerm_subnet" "mysql" {
  name                 = "snet-LCACollab-mysql-prd-weu"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.mysql_address_prefix]
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
  name                = "${var.resource_group_name}.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "vnetzone-mysql-${var.resource_group_name}.com"
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = azurerm_virtual_network.lcacollab.id
}
