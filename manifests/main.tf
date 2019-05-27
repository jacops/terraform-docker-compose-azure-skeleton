terraform {
  backend "azurerm" {
    key            = "main.tfstate"
    container_name = "tfstate"
  }
}

provider "azurerm" {
  version = "~> 1.29"
}
