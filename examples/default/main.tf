provider "azurerm" {
  features {}
  environment                     = "usgovernment"
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
  resource_providers_to_register = [
    "Microsoft.OperationalInsights",
    "Microsoft.OperationsManagement",
    "Microsoft.SecurityInsights",
  ]
}

module "sentinel" {
  source = "../.."

  resource_group_name          = var.resource_group_name
  location                     = var.location
  log_analytics_workspace_id   = var.log_analytics_workspace_id
  log_analytics_workspace_name = var.log_analytics_workspace_name
  tags                         = var.tags
}
