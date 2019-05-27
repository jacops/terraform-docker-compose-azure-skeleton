variable "vnet_cidr" {
  default = ["10.0.0.0/16"]
  type = "list"
}

resource "azurerm_virtual_network" "main" {
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  name                = "${local.resource_affix}main-vnet"
  address_space       = var.vnet_cidr

  tags = "${merge(
    local.common_tags,
    map(
      "Role", "MainVnet"
    )
  )}"
}
