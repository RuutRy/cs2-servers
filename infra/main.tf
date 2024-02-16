
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

module "container_registry" {
  source = "./module/container_registry"

  location = azurerm_resource_group.rg.location
  rg_name  = azurerm_resource_group.rg.name
}
