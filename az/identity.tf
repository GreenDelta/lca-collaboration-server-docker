resource "azurerm_user_assigned_identity" "lcacollab" {
  name                = "id-lcacollab"
  resource_group_name = azurerm_resource_group.lcacollab.name
  location            = var.location
}

resource "azurerm_role_assignment" "lcacollab_file_share_access" {
  scope                = azurerm_storage_account.lcacollab.id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = azurerm_user_assigned_identity.lcacollab.principal_id
}
