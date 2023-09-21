# terraform-azurerm-sentinel

This configures  sentinel on the management plane log analytics workspace.

## Description

This module deploys sentinel and configures it with a Log Analytics Workspace. This repo also contains KQL example queries and a PowerShell script to create Sentinel Rule Analytics.

## Dependencies

- Security Core

## Code updates

`tstate.tf` Update to the appropriate version and storage accounts, see sample

```hcl
terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.45.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "core-rg"
    storage_account_name = "tfstate"
    container_name       = "statecontainer"
    environment          = "usgovernment"
    key                  = "mgmt-sentinel.tfstate"
  }
}
```

## Deployment steps

Change directory to the `mgmt/sentinel` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the policies state key

Rerun `terraform apply` to update all changes

### Data Connectors

At the time of deployment there wasn't a lot of terraform support for configuring sentinel. Engineers need to manually configure the following:

- Azure Active Directory: enable Sign-in Logs and Audit Logs
- Microsoft Defender for Cloud: Enable incidents to generate Sentinel Incidents
- Azure Activity: Use the Azure Policy Wizard to configure all subs in the management group
- Azure Firewall
- Azure Key Vault
- Azure Kubernetes Service
- Azure SQL Databases
- Azure Web Application Firewall
- Network Security Groups
- Office 365 (if applicable)
- Security Events via Legacy Agent (if applicable)
- Syslog (if applicable)

### Pricing

Default pricing is free for 30 days, then PAYG per gigabyte of data processed. For more information, refer to the [Azure docs](https://azure.microsoft.com/en-us/pricing/details/azure-sentinel/). For some customers this may be sufficient, for others it may be necessary to change to a dedicated pricing model. Note most pricing models have a 30 day price fix. Meaning if you enable 100/gb day the customer will be required to pay for 100gb/day for 30 days. After 30 days the customer can change the pricing model.

## Additional information

Sentinel analytics are configured via the Azure Portal. For more information, refer to the [Azure docs](https://docs.microsoft.com/en-us/azure/sentinel/tutorial-monitor-your-data).

The default data retention is configured in the Log Analytics Workspace. The retention is set to 1 year for all data. By default, this keeps data active for live queries in Sentinel for one year. It is possible to archive data with Log Analytics. This is set on a table by table basis, see [Data Retention](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-archive?tabs=cli-1%2Ccli-2) for more information. The best way to implement this is create a powershell script to loop through the available tables and call the `azcli` command to set the table archive policy.

## Next Steps

Set-TableRetention.ps1: Powershell script for setting data retention on tables to FedRAMP standards.
RuleAnalytics folder: Starting point for creating analytics rules in Sentinel.
kqlQueries folder: Handful of useful KQL queries.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | = 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_solution.sentinel](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/log_analytics_solution) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->