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

