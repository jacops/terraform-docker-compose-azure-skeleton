resource "azurerm_resource_group" "network" {
  location = var.location
  name     = "${local.resource_affix}network-rg"

  tags = local.common_tags
}

output "rg_network" {
  value = azurerm_resource_group.network.name
}
