resource "azurerm_virtual_network" "lcacollab" {
  name                = "vnet-lcacollab"
  location            = var.location
  resource_group_name = azurerm_resource_group.lcacollab.name
  address_space       = [var.address_space]
}

# App Gateway
resource "azurerm_subnet" "public" {
  name                 = "snet-public"
  resource_group_name  = azurerm_resource_group.lcacollab.name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.public_address_prefix]
}

resource "azurerm_public_ip" "app_gateway" {
  name                = "pip-vgw-lcacollab"
  location            = azurerm_resource_group.lcacollab.location
  resource_group_name = azurerm_resource_group.lcacollab.name
  allocation_method   = "Static"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.lcacollab.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.lcacollab.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.lcacollab.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.lcacollab.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.lcacollab.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.lcacollab.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.lcacollab.name}-rdrcfg"
}

resource "azurerm_application_gateway" "lcacollab" {
  name                = "vgw-lcacollab"
  resource_group_name = azurerm_resource_group.lcacollab.name
  location            = azurerm_resource_group.lcacollab.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "lcacollab-gateway-ip-configuration"
    subnet_id = azurerm_subnet.public.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 8080
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [azurerm_container_group.lcacollab.ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

# Bastion
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.lcacollab.name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.bastion_address_prefix]
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion"
  resource_group_name = azurerm_resource_group.lcacollab.name
  location            = azurerm_resource_group.lcacollab.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-host"
  resource_group_name = azurerm_resource_group.lcacollab.name
  location            = azurerm_resource_group.lcacollab.location

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
