#TODO: Update this to your local disk 
$LogFile = "/Users/tkennedy/REPOS/ACE-AzureSentinel-RuleAdditionAutomation-Azure/output.txt"

if (Test-Path $LogFile)
{ 
    $latest = Get-ChildItem -Path $DestinationFolder| Sort-Object Name -Descending | Select-Object -First 1
    #split the latest filename, increment the number, then re-assemble new filename:
    $newFileName = $latest.BaseName.Split('_')[0] + "_" + ([int]$latest.BaseName.Split('_')[1] + 1).ToString() + $latest.Extension
    $LogFile = $newFileName
}

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $LogFile

# Check if needed modules are installed if not install them
if (Get-Module -ListAvailable -Name Az.Accounts) {
  Write-Host "Module Az.Accounts exists" -ForegroundColor Green
  Import-Module Az.Accounts
} 
else {
  Write-Host "Module Az.Accounts does not exist, installing it." -ForegroundColor Yellow
  install-module Az.Accounts
}

if (!(Get-AzContext)){
  Connect-AzAccount -EnvironmentName AzureUSGovernment
  #Select-AzSubscription -Current -SubscriptionName Staging
}

import-module .\alertRuleFromGHToSentinel.psm1 -Force

# TODO: Change these for the project you are working on
$rg = "ar-prod-va-mp-core-rg"
$ws = "ar-prod-va-mp-la-1"


# If you are getting multiple errors check that the Sentinal .yaml rules exist
New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Azure%20Active%20Directory/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Azure%20Activity/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Azure%20Key%20Vault/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Apache%20Log4j%20Vulnerability%20Detection/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Azure%20Web%20Application%20Firewall%20(WAF)/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Azure%20Firewall/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Windows%20Server%20DNS/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Microsoft%20365%20Defender/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/MicrosoftDefenderForEndpoint/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Detections/SecurityAlert" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Azure%20Active%20Directory/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Detections/CommonSecurityLog" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Detections/MultipleDataSources" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Legacy%20IOC%20based%20Threat%20Protection/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Detections/SecurityNestedRecommendation" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Threat%20Intelligence/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Zscaler%20Private%20Access%20(ZPA)/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Syslog/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Windows%20Security%20Events/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Azure%20SQL%20Database%20solution%20for%20sentinel/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Endpoint%20Threat%20Protection%20Essentials/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Microsoft%20Defender%20for%20Cloud/Analytic%20Rules" -isGitHubDirectoryUrl $true

New-AzSentinelAlertRuleFromGitHub -resourceGroupName $rg -workspaceName $ws -gitHubRawUrl "https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Tomcat/Analytic%20Rules" -isGitHubDirectoryUrl $true


Stop-Transcript