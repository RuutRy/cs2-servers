resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_container_group" "cs2" {
  name                = "${var.container_group_name_prefix}-${random_string.container_name.result}"
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
      name       = "cs_files"
      mount_path = "/root/cs2-dedicated"
    }
  }

  tags = var.tags
}
