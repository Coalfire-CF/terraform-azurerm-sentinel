module "sentinel_key" {
  source = "git::https://github.com/Coalfire-CF/terraform-azurerm-key-vault//modules/kv_key?ref=v1.1.3"

  name         = var.key_name
  key_vault_id = var.key_vault_id
  key_type     = var.key_type
  key_size     = var.key_size

  # Custom rotation policy
  rotation_policy_enabled     = var.rotation_policy_enabled
  rotation_expire_after       = var.rotation_expire_after
  rotation_time_before_expiry = var.rotation_time_before_expiry

  tags = var.regional_tags
}


# Link the Customer Managed Key to the workspace
resource "azurerm_log_analytics_workspace_customer_managed_key" "sentinel" {
  log_analytics_workspace_id = var.log_analytics_workspace_id
  key_vault_key_id          = module.sentinel_key.key_id

  depends_on = [
    module.sentinel_key
  ]
}