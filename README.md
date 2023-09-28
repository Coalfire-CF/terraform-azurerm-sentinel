![Coalfire](coalfire_logo.png)

# terraform-azurerm-sentinel

## Description

This module deploys Sentinel and configures it with a Log Analytics Workspace. This repo also contains a PowerShell Script to set table log retention periods and KQL example queries.

This module is used in the [Coalfire-Azure-RAMPpak](https://github.com/Coalfire-CF/Coalfire-Azure-RAMPpak) FedRAMP Framework. 

Learn more at [Coalfire OpenSource](https://coalfire.com/opensource).

## Dependencies

- Security Core

## Code updates

If using the [Coalfire-Azure-RAMPpak](https://github.com/Coalfire-CF/Coalfire-Azure-RAMPpak) FedRAMP Framework, update `tstate.tf` to the appropriate version and storage accounts, see sample:

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

## Usage

```hcl
provider "azurerm" {
  features {}
}

module "sentinel" {
  source                    = "github.com/Coalfire-CF/terraform-azurerm-sentinel"

  name                         = "${var.resource_prefix}-sentinel"
  resource_group_name          = azurerm_resource_group.management.name
  location                     = var.location
  log_analytics_workspace_id   = data.terraform_remote_state.core.outputs.core_la_workspace_id
  log_analytics_workspace_name = data.terraform_remote_state.core.outputs.core_la_workspace_name

  global_tags = var.global_tags
  regional_tags = var.regional_tags
}
```

## Next Steps

/TableRetention/Set-TableRetention.ps1: Powershell script for setting data retention on tables to FedRAMP standards.

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

### Additional information

Sentinel analytics are configured via the Azure Portal. For more information, refer to the [Azure docs](https://docs.microsoft.com/en-us/azure/sentinel/tutorial-monitor-your-data).

The default data retention is configured in the Log Analytics Workspace. The retention is set to 1 year for all data. By default, this keeps data active for live queries in Sentinel for one year. It is possible to archive data with Log Analytics. This is set on a table by table basis, see [Data Retention](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-archive?tabs=cli-1%2Ccli-2) for more information. The best way to implement this is create a powershell script to loop through the available tables and call the `azcli` command to set the table archive policy.


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_solution.sentinel](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | Global level tags | `map(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure location/region to create resources in. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | ID of the Log Analytics Workspace diagnostic logs should be sent to | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of the Log Analytics Workspace Name diagnostic logs should be sent to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of Sentinel | `string` | n/a | yes |
| <a name="input_regional_tags"></a> [regional\_tags](#input\_regional\_tags) | Regional level tags | `map(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resouce Group of Sentinel | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

[Start Here](CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Contact Us

[Coalfire](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
