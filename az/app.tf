resource "azurerm_container_group" "lcacollab" {
  name                = "cg-lcacollab"
  location            = azurerm_resource_group.lcacollab.location
  resource_group_name = azurerm_resource_group.lcacollab.name
  os_type             = "Linux"
  subnet_ids          = [azurerm_subnet.app.id]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.lcacollab.id]
  }

  container {
    name   = "lcacollab"
    image  = "registry.greendelta.com/hub/collaboration-server:${var.lcacollab_version}"
    cpu    = "2"
    memory = "2"

    environment_variables = {
      MYSQL_URL      = module.mysql.url
      MYSQL_PORT     = "3306"
      MYSQL_DATABASE = var.mysql_database
      MYSQL_USER     = var.MYSQL_ROOT_USER
      MYSQL_PASSWORD = var.MYSQL_ROOT_PASSWORD
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
