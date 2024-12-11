resource "azurerm_subnet" "app" {
  name                              = "snet-LCACollab-app-prd-weu"
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.lcacollab.name
  address_prefixes                  = [var.app_address_prefix]
  private_endpoint_network_policies = "Enabled"
  service_endpoints                 = ["Microsoft.Storage"]

  delegation {
    name = "aci-app"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}
