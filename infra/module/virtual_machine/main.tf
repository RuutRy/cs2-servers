resource "azurerm_public_ip" "game" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    hostName = var.server_name
  }
}

resource "azurerm_network_interface" "game" {
  name                = "game-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    public_ip_address_id          = azurerm_public_ip.game.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "game" {
  name                = var.server_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.server_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.game.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${module.path}/../../config/id_ed25519.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 50
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
