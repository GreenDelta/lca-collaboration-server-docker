resource "azurerm_resource_group" "lcacollab" {
  name     = "rg-lcacollab"
  location = var.location
}

resource "azurerm_user_assigned_identity" "lcacollab" {
  name                = "id-lcacollab"
  resource_group_name = azurerm_resource_group.lcacollab.name
  location            = var.location
}

module "elasticsearch" {
  source               = "./elasticsearch"
  count                = var.ELASTICSEARCH_ADMIN_USER != "" ? 1 : 0
  resource_group_name  = azurerm_resource_group.lcacollab.name
  location             = azurerm_resource_group.lcacollab.location
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefix       = var.elasticsearch_address_prefix
  app_address_prefix   = var.app_address_prefix
  admin_user           = var.ELASTICSEARCH_ADMIN_USER
}

module "mysql" {
  source               = "./mysql"
  resource_group_name  = azurerm_resource_group.lcacollab.name
  location             = azurerm_resource_group.lcacollab.location
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  virtual_network_id   = azurerm_virtual_network.lcacollab.id
  address_prefix       = var.mysql_address_prefix
  root_user            = var.MYSQL_ROOT_USER
  root_password        = var.MYSQL_ROOT_PASSWORD
}
