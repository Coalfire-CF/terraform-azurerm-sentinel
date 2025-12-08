resource "azurerm_sentinel_log_analytics_workspace_onboarding" "example" {
  workspace_id                 = var.log_analytics_workspace_id
  customer_managed_key_enabled = var.customer_managed_key_enabled
}

resource "azurerm_log_analytics_solution" "sentinel" {
  solution_name         = "SecurityInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = var.log_analytics_workspace_id
  workspace_name        = var.log_analytics_workspace_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}
