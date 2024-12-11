terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.13.0"
    }
  }
}

# Configure Azure provider
provider "azurerm" {
  features {}

  subscription_id = var.SUBSCRIPTION_ID
}
