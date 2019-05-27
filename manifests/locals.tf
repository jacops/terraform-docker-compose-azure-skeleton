locals {
  resource_affix = "${var.environment}-"
  common_tags = {
    Source      = "Terraform"
    Owner       = data.azurerm_client_config.current.client_id
    Environment = var.environment
  }
}
