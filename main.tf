resource "azurerm_log_analytics_solution" "sentinel" {
  solution_name         = "SecurityInsights"
  location              = var.location
  resource_group_name   = data.terraform_remote_state.core.outputs.core_rg_name
  workspace_resource_id = data.terraform_remote_state.core.outputs.core_la_workspace_id
  workspace_name        = data.terraform_remote_state.core.outputs.core_la_workspace_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

# It appears enabling this manually may not be required. Initial deployment showed this getting enabled based on the logs
# already existing in the workspace. This may be a bug, but it's not clear if this is required or not.

# resource "azurerm_sentinel_data_connector_azure_active_directory" "sentinel-aad" {
#   name                       = "AAD-Connector"
#   log_analytics_workspace_id = data.terraform_remote_state.core.outputs.core_la_workspace_id
# }
