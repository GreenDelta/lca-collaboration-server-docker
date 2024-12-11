resource "azurerm_virtual_network" "lcacollab" {
  name                = "vnet-LCACollab-prd-weu"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.address_space]
}
