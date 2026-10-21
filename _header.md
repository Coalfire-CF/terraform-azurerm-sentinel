![Coalfire](coalfire_logo.png)

# terraform-azurerm-sentinel

## Description

This module deploys Sentinel and configures it with a Log Analytics Workspace. Sentinel can only be connected to one Log Analytics Workspace. This repo also contains a PowerShell Script to set table log retention periods and KQL example queries.

This module is used in the [Coalfire-Azure-RAMPpak](https://github.com/Coalfire-CF/Coalfire-Azure-RAMPpak) FedRAMP Framework. 

Learn more at [Coalfire OpenSource](https://coalfire.com/opensource).

## Dependencies

- An existing Log Analytics workspace. This module does not create it.
- The `Microsoft.OperationalInsights`, `Microsoft.OperationsManagement` and `Microsoft.SecurityInsights` resource providers registered in the subscription.

## Usage

The module has no provider block. The caller configures `azurerm` for Azure Government. See [examples/default](examples/default) for a complete root.

```hcl
module "sentinel" {
  source = "git::https://github.com/Coalfire-CF/terraform-azurerm-sentinel?ref=v2.0.0"

  resource_group_name          = "example-rg"
  location                     = "usgovvirginia"
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.this.id
  log_analytics_workspace_name = azurerm_log_analytics_workspace.this.name

  tags = var.tags
}
```

## Next Steps

Update `TableRetention/tableList.csv` for each environment. Table names differ between environments.

/TableRetention/Set-TableRetention.ps1: Powershell script for setting data retention on tables to FedRAMP standards.

### Data Connectors

At the time of deployment there wasn't a lot of terraform support for configuring sentinel. Engineers need to manually configure the following:

- Azure Active Directory: enable Sign-in Logs and Audit Logs
- Microsoft Defender for Cloud: Enable incidents to generate Sentinel Incidents
- Azure Activity: Use the Azure Policy Wizard to configure all subs in the management group
- Azure Firewall
- Azure Key Vault
- Azure Kubernetes Service
- Azure Storage Account
- Microsoft Defender XDR (if applicable)
- Microsoft Entra ID
- Microsoft Entra ID Protection
- Azure SQL Databases
- Azure Web Application Firewall
- Network Security Groups
- Office 365 (if applicable)
- Security Events via Legacy Agent (if applicable)
- Syslog (if applicable)

### Pricing

Default pricing is free for 30 days, then PAYG per gigabyte of data processed. For more information, refer to the [Azure docs](https://azure.microsoft.com/en-us/pricing/details/azure-sentinel/). For some customers this may be sufficient, for others it may be necessary to change to a dedicated pricing model. Note most pricing models have a 30 day price fix. Meaning if you enable 100/gb day the customer will be required to pay for 100gb/day for 30 days. After 30 days the customer can change the pricing model.

### Additional information

Sentinel analytics are configured via the Azure Portal. For more information, refer to the [Azure docs](https://docs.microsoft.com/en-us/azure/sentinel/tutorial-monitor-your-data).

The default data retention is configured in the Log Analytics Workspace. The retention is set to 1 year for all data. By default, this keeps data active for live queries in Sentinel for one year. It is possible to archive data with Log Analytics. This is set on a table by table basis, see [Data Retention](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-archive?tabs=cli-1%2Ccli-2) for more information. The best way to implement this is create a powershell script to loop through the available tables and call the `azcli` command to set the table archive policy.


