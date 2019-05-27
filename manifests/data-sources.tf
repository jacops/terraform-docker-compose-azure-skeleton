variable "terraform_storage_account_name" {}
variable "terraform_resource_group_name" {}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

//This is a sample definition of getting values from other state file
//
//data "terraform_remote_state" "subscription" {
//  backend = "azurerm"
//  config = {
//    key                  = "subscription.tfstate"
//    container_name       = "tfstate"
//    storage_account_name = var.terraform_storage_account_name
//    resource_group_name  = var.terraform_resource_group_name
//  }
//}
//
//resource "azurerm_network_watcher" "main" {
//  location = var.location
//  name = "default"
//  resource_group_name = data.subscription.outputs.rg_network
//}
