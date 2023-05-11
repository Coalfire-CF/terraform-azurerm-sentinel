# ACE-AzureSentinel-RuleAdditionAutomation-Azure

Templates for Azure Sentinel Automated Analytic Rule additions. This folder should be used as a start for using Sentinel's Analytic Rules after Sentinel has been deployed.

## Setup and usage

Some environments have different products. You may have to add Sentinel alerts for what your environment's products are. Append `Azure_Sentinel_Rule_Import.ps1` with new alerts to create.

#### Code Location

Code should be stored in terraform/mgmt/sentinel

#### Code updates

When you run this you may see errors spit out. This primarily happens because of two reasons:

1. No log table exists in the Log Analytics Workspace
1. Error with the alert query

Microsoft is updating Sentinel's alert database. Reference <https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/> to see if new alerts are there to log.

**NOTE** Some environments have different products. You may have to add Sentinel alerts for what your environment's products are. Append `Azure_Sentinel_Rule_Import.ps1` with new alerts to create.
