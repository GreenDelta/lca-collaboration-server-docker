resource "azurerm_resource_group" "lcacollab" {
  name     = "rg-LCACollab-prd-weu"
  location = "westeurope"
}

module "lcacollab" {
  source = "./prd"

  resource_group_name      = azurerm_resource_group.lcacollab.name
  location                 = azurerm_resource_group.lcacollab.location
  mysql_root_user          = var.MYSQL_ROOT_USER
  mysql_root_password      = var.MYSQL_ROOT_PASSWORD
  elasticsearch_admin_user = var.ELASTICSEARCH_ADMIN_USER
}

output "lcacollab" {
  value = module.lcacollab
  sensitive = true
}
