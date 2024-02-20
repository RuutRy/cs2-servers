
locals {
  tags = { azd-env-name : var.environment_name, managed-by : "terraform", project : "cs2-servers" }
}
# ------------------------------------------------------------------------------------------------------
# Deploy resource Group
# ------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = "cs2-servers"
  location = var.location

  tags = local.tags
}

# ------------------------------------------------------------------------------------------------------
# Virtual networks for game servers
# ------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "cs_network" {
  name                = "cs-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "cs_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.cs_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

# ------------------------------------------------------------------------------------------------------
# DNS
# ------------------------------------------------------------------------------------------------------

resource "azurerm_dns_zone" "games_ruut" {
  name                = "pelit.ruut.me"
  resource_group_name = azurerm_resource_group.rg.name
}
