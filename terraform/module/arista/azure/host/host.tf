resource "azurerm_network_interface" "intf" {
  location            = var.rg_location
  resource_group_name = var.rg_name
  name                = var.intf_name

  ip_configuration {
    name                          = var.intf_name
    subnet_id                     = var.subnet_id
    private_ip_address            = var.private_ip
    private_ip_address_allocation = "Static"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "host" {
  name                          = var.tags["Name"]
  location                      = var.rg_location
  resource_group_name           = var.rg_name
  network_interface_ids         = [azurerm_network_interface.intf.id]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  zones                         = [var.zone]
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = var.disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.tags["Name"]
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.tags
}
