
locals {
  tags = { azd-env-name : var.environment_name, managed-by : "terraform", project : "cs2-servers" }
  servers = {
    cs1 = { size = "Standard_D4as_v4" },
    cs2 = { size = "Standard_D4as_v4" }
  }
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

resource "cloudflare_record" "name_servers" {
  for_each = azurerm_dns_zone.games_ruut.name_servers

  zone_id = var.cloudflare_zone_id
  name    = "pelit.ruut.me"
  type    = "NS"
  value   = each.value

  depends_on = [azurerm_dns_zone.games_ruut]
}

# ------------------------------------------------------------------------------------------------------
# Game servers
# ------------------------------------------------------------------------------------------------------

module "virtual_machines" {
  source   = "./module/virtual_machine"
  for_each = local.servers

  rg_name     = azurerm_resource_group.rg.name
  location    = azurerm_resource_group.rg.location
  subnet_id   = azurerm_subnet.cs_subnet.id
  zone_name   = azurerm_dns_zone.games_ruut.name
  server_name = each.key
  server_size = each.value.size
}
