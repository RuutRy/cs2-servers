resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_storage_account" "game" {
  name                     = "cs2serverfiles"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "game" {
  name                 = "cs2-game-share"
  storage_account_name = azurerm_storage_account.game.name
  quota                = 50
}

resource "azurerm_container_group" "cs2" {
  name                = "${var.container_group_name_prefix}${random_string.container_name.result}"
  location            = var.location
  resource_group_name = var.rg_name
  ip_address_type     = "Public"
  os_type             = "Linux"

  exposed_port {
    port     = 27015
    protocol = "TCP"
  }

  exposed_port {
    port     = 27015
    protocol = "UDP"
  }

  exposed_port {
    port     = 27020
    protocol = "UDP"
  }

  container {
    name   = "cs2"
    image  = "juksuu/cs2:matchup"
    cpu    = "6"
    memory = "10"

    ports {
      port     = 27015
      protocol = "TCP"
    }

    ports {
      port     = 27015
      protocol = "UDP"
    }

    ports {
      port     = 27020
      protocol = "UDP"
    }

    volume {
      name       = "csfiles"
      mount_path = "/root/cs2-dedicated"
      read_only  = false
      share_name = azurerm_storage_share.game.name

      storage_account_name = azurerm_storage_account.game.name
      storage_account_key  = azurerm_storage_account.game.primary_access_key

    }
  }

  tags = var.tags
}
