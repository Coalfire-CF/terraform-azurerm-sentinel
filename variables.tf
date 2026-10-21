variable "resource_group_name" {
  description = "Name of the resource group for the SecurityInsights solution. Use the Log Analytics workspace's resource group."
  type        = string
}

variable "location" {
  description = "The Azure location/region to create resources in."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the SecurityInsights solution."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace to onboard to Microsoft Sentinel."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace to onboard to Microsoft Sentinel. Must match log_analytics_workspace_id."
  type        = string
}

variable "customer_managed_key_enabled" {
  description = "Set to true to onboard Sentinel with a customer-managed key. Only available for workspaces linked to a dedicated Log Analytics cluster that already has a customer-managed key."
  type        = bool
  default     = false
}
