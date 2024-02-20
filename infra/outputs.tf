output "AZURE_LOCATION" {
  value = var.location
}
/*
output "cs_ip" {
  value = module.container_group.cs_ip
}

output "fqdn" {
  value = module.container_group.fqdn
}
*/

output "ns" {
  value = azurerm_dns_zone.games_ruut.name_servers
}
