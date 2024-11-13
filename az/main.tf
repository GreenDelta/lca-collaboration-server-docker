# Create Resource Group
resource "azurerm_resource_group" "lcacollab" {
  name     = "rg-lcacollab"
  location = var.location
}
