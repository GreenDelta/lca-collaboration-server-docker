module "network" {
  source              = "./network"
  resource_group_name = var.resource_group_name
  location            = var.location
  with_elasticsearch  = var.elasticsearch_admin_user != ""
}

module "elasticsearch" {
  source               = "./elasticsearch"

  count                = var.elasticsearch_admin_user != "" ? 1 : 0
  resource_group_name  = var.resource_group_name
  location             = var.location
  virtual_network_name = module.network.virtual_network_id
  address_prefix       = var.elasticsearch_address_prefix
  app_address_prefix   = var.app_address_prefix
  admin_user           = var.elasticsearch_admin_user
}

module "mysql" {
  source              = "./mysql"

  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.mysql_subnet_id
  root_user           = var.mysql_root_user
  root_password       = var.mysql_root_password
}

module "gateway" {
  source               = "./gateway"
  
  resource_group_name  = var.resource_group_name
  location             = var.location
  virtual_network_name = module.network.virtual_network_name
  app_private_ip       = azurerm_container_group.lcacollab.ip_address
}
