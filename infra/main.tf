
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
# Deploy Container Registry
# ------------------------------------------------------------------------------------------------------
/*
module "container_group" {
  source = "./module/container_group"

  location                    = azurerm_resource_group.rg.location
  rg_name                     = azurerm_resource_group.rg.name
  tags                        = local.tags
  container_group_name_prefix = "csservers"
}
*/
