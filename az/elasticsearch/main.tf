resource "azurerm_linux_virtual_machine" "this" {
  name                  = "vm-elasticsearch"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_DS2_v2"
  computer_name         = "elasticsearch"
  admin_username        = var.admin_user
  network_interface_ids = [azurerm_network_interface.this.id]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file("~/.ssh/id_rsa.pub")
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

resource "null_resource" "provision" {
  provisioner "remote-exec" {
    connection {
      host        = azurerm_linux_virtual_machine.this.public_ip_address
      user        = var.admin_user
      type        = "ssh"
      private_key = file("~/.ssh/id_rsa")
      agent       = false
    }
    inline = ["echo 'Elasticsearch up and running'"]
  }

  provisioner "local-exec" {
    command = <<EOT
      ansible-galaxy role install geerlingguy.elasticsearch geerlingguy.java &&
      ansible-playbook \
        -i "${azurerm_linux_virtual_machine.this.public_ip_address}," \
        -u "${var.admin_user}" \
        --ssh-extra-args="-o StrictHostKeyChecking=no" \
        ${path.module}/install_elasticsearch.yml
    EOT
  }
}
