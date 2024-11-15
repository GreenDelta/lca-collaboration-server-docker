resource "azurerm_subnet" "this" {
  address_prefixes     = [var.address_prefix]
  name                 = "snet-mysql"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
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

resource "azurerm_private_dns_zone" "this" {
  name                = "${var.resource_group_name}.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "vnetzone-mysql-${var.resource_group_name}.com"
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.virtual_network_id
}
