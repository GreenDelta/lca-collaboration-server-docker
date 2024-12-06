resource "azurerm_virtual_network" "lcacollab" {
  name                = "vnet-lcacollab"
  location            = var.location
  resource_group_name = azurerm_resource_group.lcacollab.name
  address_space       = [var.address_space]
}

# App subnet
resource "azurerm_subnet" "app" {
  name                              = "snet-app"
  resource_group_name               = azurerm_resource_group.lcacollab.name
  virtual_network_name              = azurerm_virtual_network.lcacollab.name
  address_prefixes                  = [var.app_address_prefix]
  private_endpoint_network_policies = "Enabled"
  service_endpoints                 = ["Microsoft.Storage"]

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

# File share subnet
resource "azurerm_subnet" "storage" {
  name                 = "snet-file"
  resource_group_name  = azurerm_resource_group.lcacollab.name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.storage_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.storage.core.windows.net"
  resource_group_name = azurerm_resource_group.lcacollab.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = "vnetzone-fileshare-${azurerm_resource_group.lcacollab.name}.com"
  resource_group_name   = azurerm_resource_group.lcacollab.name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = azurerm_virtual_network.lcacollab.id
}

resource "azurerm_private_endpoint" "storage" {
  name                = "pe-fileshare-lcacollab"
  location            = var.location
  resource_group_name = azurerm_resource_group.lcacollab.name
  subnet_id           = azurerm_subnet.storage.id

  private_service_connection {
    name                           = "psc-fileshare-lcacollab"
    private_connection_resource_id = azurerm_storage_account.lcacollab.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "pdnsz-fileshare-lcacollab"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }
}

# App Gateway
resource "azurerm_subnet" "public" {
  name                 = "snet-public"
  resource_group_name  = azurerm_resource_group.lcacollab.name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.public_address_prefix]
}

resource "azurerm_public_ip" "app_gateway" {
  name                = "pip-gw-lcacollab"
  location            = azurerm_resource_group.lcacollab.location
  resource_group_name = azurerm_resource_group.lcacollab.name
  allocation_method   = "Static"
  domain_name_label   = "lcacollab"
}

locals {
  backend_address_pool_name          = "${azurerm_virtual_network.lcacollab.name}-beap"
  frontend_http_port_name            = "${azurerm_virtual_network.lcacollab.name}-feport-http"
  frontend_https_port_name           = "${azurerm_virtual_network.lcacollab.name}-feport-https"
  frontend_ip_configuration_name     = "${azurerm_virtual_network.lcacollab.name}-feip"
  ssl_certificate_name               = "${azurerm_virtual_network.lcacollab.name}-sslcert"
  http_settings_name                 = "${azurerm_virtual_network.lcacollab.name}-be-htst"
  listener_http_name                 = "${azurerm_virtual_network.lcacollab.name}-httplstn"
  listener_https_name                = "${azurerm_virtual_network.lcacollab.name}-httpslstn"
  request_routing_rule_http_to_https = "${azurerm_virtual_network.lcacollab.name}-rrr-http-https"
  request_routing_rule_backend       = "${azurerm_virtual_network.lcacollab.name}-rrr-backend"
  redirect_configuration_name        = "${azurerm_virtual_network.lcacollab.name}-rdrcfg"
}

resource "azurerm_application_gateway" "lcacollab" {
  name                = "gw-lcacollab"
  resource_group_name = azurerm_resource_group.lcacollab.name
  location            = azurerm_resource_group.lcacollab.location
  enable_http2        = true

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
    name = local.frontend_http_port_name
    port = 80
  }

  frontend_port {
    name = local.frontend_https_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  ssl_certificate {
    name     = local.ssl_certificate_name
    data     = filebase64("${var.SSL_CERT_FILE}")
    password = var.SSL_CERT_PASSWORD
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [azurerm_container_group.lcacollab.ip_address]
  }

  backend_http_settings {
    name                  = local.http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_http_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_http_port_name
    protocol                       = "Http"
  }

  http_listener {
    name                           = local.listener_https_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_https_port_name
    protocol                       = "Https"
    ssl_certificate_name           = local.ssl_certificate_name
  }

  request_routing_rule {
    name                        = local.request_routing_rule_http_to_https
    priority                    = 9
    rule_type                   = "Basic"
    http_listener_name          = local.listener_http_name
    redirect_configuration_name = local.redirect_configuration_name
  }

  request_routing_rule {
    name                       = local.request_routing_rule_backend
    priority                   = 8
    rule_type                  = "Basic"
    http_listener_name         = local.listener_https_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_settings_name
  }

  redirect_configuration {
    name                 = local.redirect_configuration_name
    redirect_type        = "Permanent"
    target_listener_name = local.listener_https_name
  }
}
