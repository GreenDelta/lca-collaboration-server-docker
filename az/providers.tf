terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.12.0"
    }
  }
}

# Configure Azure provider
provider "azurerm" {
  features {}

  subscription_id = var.AZURE_SUBSCRIPTION_ID
}
