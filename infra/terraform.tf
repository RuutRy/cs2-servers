terraform {
  required_version = "~> 1.4"

  backend "azurerm" {
    resource_group_name  = "terrafrom-resorce-group-www"
    storage_account_name = "cs2server"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.26"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
  use_oidc = true
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
