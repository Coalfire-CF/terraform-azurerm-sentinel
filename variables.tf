variable "name" {
  description = "Name of Sentinel"
  type        = string
}

variable "resource_group_name" {
  description = "Resouce Group of Sentinel"
  type        = string
}

variable "location" {
  description = "The Azure location/region to create resources in."
  type        = string
}

variable "global_tags" {
  type        = map(string)
  description = "Global level tags"
}

variable "regional_tags" {
  type        = map(string)
  description = "Regional level tags"
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace diagnostic logs should be sent to"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace Name diagnostic logs should be sent to"
  type        = string
}
