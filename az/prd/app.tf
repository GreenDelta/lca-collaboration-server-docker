resource "azurerm_container_group" "lcacollab" {
  name                = "cg-LCACollab-prd-weu"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  subnet_ids          = [module.network.app_subnet_id]

  container {
    name   = "lcacollab"
    image  = "registry.greendelta.com/hub/collaboration-server:${var.lcacollab_version}"
    cpu    = "2"
    memory = "2"

    environment_variables = {
      MYSQL_URL      = module.mysql.url
      MYSQL_PORT     = "3306"
      MYSQL_DATABASE = var.mysql_database
      MYSQL_USER     = var.mysql_root_user
      MYSQL_PASSWORD = var.mysql_root_password
    }

    ports {
      port     = 8080
      protocol = "TCP"
    }

    volume {
      name                 = "vol-lcacollab-collab"
      mount_path           = "/opt/collab"
      storage_account_name = azurerm_storage_account.lcacollab.name
      storage_account_key  = azurerm_storage_account.lcacollab.primary_access_key
      share_name           = azurerm_storage_share.lcacollab.name
    }
  }

  ip_address_type = "Private"
}
