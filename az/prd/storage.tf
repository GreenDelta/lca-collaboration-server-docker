data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}

resource "azurerm_storage_account" "lcacollab" {
  name                       = "lcacollab"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_tier               = "Standard"
  account_kind               = "StorageV2"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = true

  network_rules {
    default_action = "Deny"
    virtual_network_subnet_ids = [
      module.network.app_subnet_id,
      module.network.storage_subnet_id,
    ]
    ip_rules = [trimspace(data.http.my_ip.response_body)]
  }
}

resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.storage.lcacollab.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = "vnetzone-fileshare-${var.resource_group_name}.com"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = module.network.virtual_network_id
}

resource "azurerm_private_endpoint" "storage" {
  name                = "pe-LCACollab-fileshare-prd-weu"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network.storage_subnet_id

  private_service_connection {
    name                           = "psc-fileshare-LCACollab-prd-weu"
    private_connection_resource_id = azurerm_storage_account.lcacollab.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "pdnsz-fileshare-LCACollab-prd-weu"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }
}

resource "azurerm_storage_share" "lcacollab" {
  name                 = "collab"
  storage_account_name = azurerm_storage_account.lcacollab.name
  quota                = 8
}

resource "azurerm_storage_share_directory" "collab_directories" {
  for_each         = toset(["git", "lib"])
  name             = each.key
  storage_share_id = azurerm_storage_share.lcacollab.id
}
