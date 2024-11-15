resource "azurerm_storage_account" "lcacollab" {
  name                     = "lcacollab"
  resource_group_name      = azurerm_resource_group.lcacollab.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_role_assignment" "lcacollab_file_share_access" {
  scope                = azurerm_storage_account.lcacollab.id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = azurerm_user_assigned_identity.lcacollab.principal_id
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
