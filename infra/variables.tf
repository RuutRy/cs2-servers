variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
}

variable "principal_id" {
  description = "The Id of the azd service principal to add to deployed keyvault access policies"
  type        = string
  default     = ""
  sensitive   = true
}

variable "subscription_id" {
  description = "The current subscription id for the terraform instance"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "cloudflare API for controlling ruut.me domain"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone where ruut.me resides"
  type        = string
  sensitive   = true
}

variable "domain" {
  default     = "ruut.me"
  description = "Domain for cloudflare"
}

variable "rcon_pass" {
  default     = "changeme"
  description = "RCON password for cs servers"
  sensitive   = true
}
