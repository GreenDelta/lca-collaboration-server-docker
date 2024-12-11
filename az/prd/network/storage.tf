resource "azurerm_subnet" "storage" {
  name                 = "snet-LCACollab-storage-prd-weu"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.storage_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}
