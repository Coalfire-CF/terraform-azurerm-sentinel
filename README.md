# Microsoft Sentinel

This configures  sentinel on the management plane log analytics workspace.

## Dependencies

- Security Core
- Management Group creation

## Resource List

- Log Analytics Workspace Solutions: Security

## Code updates

`tstate.tf` Update to the appropriate version and storage accounts, see sample

```hcl
terraform {
  required_version = "1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.26.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "v1-prod-va-mp-core-rg"
    storage_account_name = "v1prodvampsatfstate"
    container_name       = "vav1tfstatecontainer"
    var.az_environment
    key                  = "va-mgmt-sentinel.tfstate"
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

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
|N/A|N/A|N/A|N/A|N/A|

## Outputs

| Name | Description |
|------|-------------|
|N/A|N/A|
