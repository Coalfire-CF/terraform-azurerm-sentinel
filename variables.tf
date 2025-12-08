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

## Key Vault Key Variables ##

variable "customer_managed_key_enabled" {
  description = "True/False if customer managed key is enabled for Sentinel."
  type = bool
  default = true
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault ID to create the key in to encrypt the registry."
}

variable "key_name" {
  description = "Name of Key for Sentinel"
  type        = string
  default     = "sentinel-cmk"
}

variable "key_type" {
  description = "The type of key to create in the Key Vault. Possible values are RSA, RSA-HSM, EC, and EC-HSM."
  type        = string
}

variable "key_size" {
  description = "The size of the key to create in the Key Vault. Possible values are 2048, 3072, and 4096 for RSA keys."
  type        = string
  default     = "4096"
}

variable "rotation_policy_enabled" {
  description = "Enable automatic key rotation policy"
  type        = bool
  default     = true
}

variable "rotation_expire_after" {
  description = "The duration after which the key rotation expires"
  type        = string
  default     = "P180D"
}

variable "rotation_time_before_expiry" {
  description = "The duration before expiry when the key rotation should occur"
  type        = string
  default     = "P30D"
}