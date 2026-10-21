# Offline test with a mocked azurerm provider. It makes no Azure calls.
# Run from the repo root: terraform init -backend=false, then terraform test.

mock_provider "azurerm" {}

variables {
  resource_group_name          = "test-rg"
  location                     = "usgovvirginia"
  log_analytics_workspace_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"
  log_analytics_workspace_name = "test-law"
  tags = {
    environment = "test"
  }
}

run "defaults" {
  command = plan

  assert {
    condition     = azurerm_sentinel_log_analytics_workspace_onboarding.this.customer_managed_key_enabled == false
    error_message = "customer_managed_key_enabled must default to false. A customer-managed key is optional (R12)."
  }

  assert {
    condition     = azurerm_sentinel_log_analytics_workspace_onboarding.this.workspace_id == var.log_analytics_workspace_id
    error_message = "Onboarding must target log_analytics_workspace_id."
  }

  assert {
    condition     = azurerm_log_analytics_solution.sentinel.workspace_resource_id == var.log_analytics_workspace_id
    error_message = "The SecurityInsights solution must target log_analytics_workspace_id."
  }

  assert {
    condition     = azurerm_log_analytics_solution.sentinel.solution_name == "SecurityInsights"
    error_message = "solution_name must be SecurityInsights."
  }

  assert {
    condition     = azurerm_log_analytics_solution.sentinel.plan[0].publisher == "Microsoft"
    error_message = "The solution plan publisher must be Microsoft."
  }

  assert {
    condition     = azurerm_log_analytics_solution.sentinel.plan[0].product == "OMSGallery/SecurityInsights"
    error_message = "The solution plan product must be OMSGallery/SecurityInsights."
  }

  assert {
    condition     = azurerm_log_analytics_solution.sentinel.tags == var.tags
    error_message = "The SecurityInsights solution must carry var.tags (R24)."
  }
}

run "customer_managed_key_opt_in" {
  command = plan

  variables {
    customer_managed_key_enabled = true
  }

  assert {
    condition     = azurerm_sentinel_log_analytics_workspace_onboarding.this.customer_managed_key_enabled == true
    error_message = "customer_managed_key_enabled = true must reach the onboarding resource."
  }
}
