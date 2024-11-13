resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.lcacollab.name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.app_address_prefix]

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

resource "azurerm_network_profile" "app" {
  name                = "np-app"
  location            = azurerm_resource_group.lcacollab.location
  resource_group_name = azurerm_resource_group.lcacollab.name

  container_network_interface {
    name = "cni-app"

    ip_configuration {
      name      = "ipconfig-app"
      subnet_id = azurerm_subnet.app.id
    }
  }
}

resource "azurerm_storage_share" "lcacollab" {
  name               = "collab"
  storage_account_id = azurerm_storage_account.lcacollab.id
  quota              = 8
}

resource "azurerm_storage_share_directory" "collab_directories" {
  for_each         = toset(["git", "lib"])
  name             = each.key
  storage_share_id = azurerm_storage_share.lcacollab.url # strangely id does not work
}

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
    name   = "collaboration-server"
    image  = "registry.greendelta.com/hub/collaboration-server:2.3"
    cpu    = "2"
    memory = "2"

    environment_variables = {
      MYSQL_URL      = azurerm_mysql_flexible_server.lcacollab.fqdn
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
