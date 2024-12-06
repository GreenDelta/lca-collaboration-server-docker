data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}

resource "azurerm_storage_account" "lcacollab" {
  name                       = "lcacollab"
  resource_group_name        = azurerm_resource_group.lcacollab.name
  location                   = var.location
  account_tier               = "Standard"
  account_kind               = "StorageV2"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = true

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.storage.id, azurerm_subnet.app.id]
    ip_rules                   = [trimspace(data.http.my_ip.response_body)]
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
