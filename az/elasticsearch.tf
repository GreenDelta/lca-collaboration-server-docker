resource "azurerm_subnet" "elasticsearch" {
  name                 = "snet-elasticsearch"
  resource_group_name  = azurerm_resource_group.lcacollab.name
  virtual_network_name = azurerm_virtual_network.lcacollab.name
  address_prefixes     = [var.elasticsearch_address_prefix]
}

resource "azurerm_public_ip" "elasticsearch" {
  name                = "pip-elasticsearch"
  location            = azurerm_resource_group.lcacollab.location
  resource_group_name = azurerm_resource_group.lcacollab.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "elasticsearch" {
  name                = "nic-elasticsearch"
  location            = azurerm_resource_group.lcacollab.location
  resource_group_name = azurerm_resource_group.lcacollab.name

  ip_configuration {
    name                          = "ip-elasticsearch"
    subnet_id                     = azurerm_subnet.elasticsearch.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.elasticsearch.id
  }
}

resource "azurerm_network_security_group" "elasticsearch" {
  name                = "nsg-elasticsearch"
  location            = azurerm_resource_group.lcacollab.location
  resource_group_name = azurerm_resource_group.lcacollab.name

  security_rule {
    name                       = "allow-app-to-elasticsearch"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9200"
    source_address_prefix      = var.app_address_prefix
    destination_address_prefix = var.elasticsearch_address_prefix
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
    destination_address_prefix = var.elasticsearch_address_prefix
  }
}

resource "azurerm_network_interface_security_group_association" "elasticsearch_nic_nsg" {
  network_interface_id      = azurerm_network_interface.elasticsearch.id
  network_security_group_id = azurerm_network_security_group.elasticsearch.id
}

resource "azurerm_linux_virtual_machine" "elasticsearch" {
  name                  = "vm-elasticsearch"
  resource_group_name   = azurerm_resource_group.lcacollab.name
  location              = azurerm_resource_group.lcacollab.location
  size                  = "Standard_DS2_v2"
  computer_name         = "elasticsearch"
  admin_username        = var.ELASTICSEARCH_ADMIN_USER
  network_interface_ids = [azurerm_network_interface.elasticsearch.id]

  admin_ssh_key {
    username   = var.ELASTICSEARCH_ADMIN_USER
    public_key = file("~/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.lcacollab.primary_blob_endpoint
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }
}

resource "null_resource" "provision_elasticsearch" {
  provisioner "remote-exec" {
    connection {
      host        = azurerm_linux_virtual_machine.elasticsearch.public_ip_address
      user        = var.ELASTICSEARCH_ADMIN_USER
      type        = "ssh"
      private_key = file("~/.ssh/id_rsa")
      agent       = false
    }
    inline = ["echo 'ElasticSearch up and running'"]
  }

  provisioner "local-exec" {
    command = <<EOT
      ansible-galaxy role install geerlingguy.elasticsearch geerlingguy.java &&
      ansible-playbook \
        -i "${azurerm_linux_virtual_machine.elasticsearch.public_ip_address}," \
        -u "${var.ELASTICSEARCH_ADMIN_USER}" \
        --ssh-extra-args="-o StrictHostKeyChecking=no" \
        install_elasticsearch.yml
    EOT
  }
}
