variable "vnet_cidr" {
  default = "10.0.0.0/16"
}

resource "azurerm_virtual_network" "main" {
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  name                = "${local.resource_affix}main-vnet"
  address_space       = [var.vnet_cidr]

  tags = "${merge(
    local.common_tags,
    map(
      "Role", "MainVnet"
    )
  )}"
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  address_prefix       = cidrsubnet(var.vnet_cidr, 8, 0)
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  address_prefix       = cidrsubnet(var.vnet_cidr, 8, 0)
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
}
