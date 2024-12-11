resource "azurerm_subnet" "elasticsearch" {
  count = var.with_elasticsearch ? 1 : 0
  
  name                 = "snet-LCACollab-elasticsearch-prd-weu"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.elasticsearch_address_prefix]
}
