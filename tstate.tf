terraform {
  required_version = "1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "core-rg"
    storage_account_name = "tfstate"
    container_name       = "statecontainer"
    environment          = "usgovernment"
    key                  = "va-mgmt-sentinel.tfstate"
  }
}
