output "sentinel_onboarding_id" {
  description = "Resource ID of the Sentinel onboarding state for the workspace."
  value       = azurerm_sentinel_log_analytics_workspace_onboarding.this.id
}

output "sentinel_solution_id" {
  description = "Resource ID of the SecurityInsights solution."
  value       = azurerm_log_analytics_solution.sentinel.id
}
