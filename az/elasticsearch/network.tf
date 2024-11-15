resource "azurerm_subnet" "this" {
  name                 = "snet-elasticsearch"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.address_prefix]
}

resource "azurerm_public_ip" "this" {
  name                = "pip-elasticsearch"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "this" {
  name                = "nic-elasticsearch"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ip-elasticsearch"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-elasticsearch"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-app-to-elasticsearch"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9200"
    source_address_prefix      = var.app_address_prefix
    destination_address_prefix = var.address_prefix
  }

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = var.address_prefix
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}
