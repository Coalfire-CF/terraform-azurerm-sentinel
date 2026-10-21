variable "subscription_id" {
  description = "Azure Government subscription ID that holds the Log Analytics workspace."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group of the Log Analytics workspace."
  type        = string
}

variable "location" {
  description = "Azure Government region of the Log Analytics workspace."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of an existing Log Analytics workspace to onboard to Microsoft Sentinel."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace. Must match log_analytics_workspace_id."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the SecurityInsights solution."
  type        = map(string)
  default     = {}
}
