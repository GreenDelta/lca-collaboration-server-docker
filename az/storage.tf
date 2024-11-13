resource "azurerm_storage_account" "lcacollab" {
  name                     = "lcacollab"
  resource_group_name      = azurerm_resource_group.lcacollab.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
