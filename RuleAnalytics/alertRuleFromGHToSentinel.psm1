# --------------------------------------------------------------------------------------------------------------
# Import AlertRules from e.g. GitHub in YAML format to Azure Sentinel 
# 
# start script by: . .\alertRuleFromGHToSentinel.ps1
# then use function: New-AzSentinelAlertRuleFromGitHub
# provide -resourceGroupName -workspaceName and -gitHubRawUrl (e.g.: "https://raw.githubusercontent.com/Azure/Azure-Sentinel/master/Detections/SecurityEvent/ExcessiveLogonFailures.yaml")
#
# Requirements: Az.SecurityInsights (Sentinel PS Module) & powershell-yaml module
# (Both will be automatically installed)
# 
# Author: @janvonkirchheim | Blog: emptyDC.com
# Edit - 1/25/23 - @tkennedy-cf - Modified due to yaml location change. Added error handling to script. Locked in versioning of modules
# --------------------------------------------------------------------------------------------------------------

# Check if needed modules are installed if not install them
if (Get-Module -ListAvailable -Name Az.SecurityInsights) {
    Write-Host "Module Az.SecurityInsights exists" -ForegroundColor Green
} 
else {
    Write-Host "Module Az.SecurityInsights does not exist, installing it." -ForegroundColor Yellow
    install-module Az.SecurityInsights -RequiredVersion 3.0.1
}
if (Get-Module -ListAvailable -Name powershell-yaml) {
    Write-Host "Module powershell-yaml exists" -ForegroundColor Green
} 
else {
    Write-Host "Module powershell-yaml does not exist, installing it." -ForegroundColor Yellow
    install-module powershell-yaml -RequiredVersion 0.4.4
}
function New-AzSentinelAlertRuleFromGitHub {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$resourceGroupName,
        [Parameter(Mandatory=$true)][string]$workspaceName,
        [Parameter(Mandatory=$true)][string]$gitHubRawUrl,
        [Parameter(Mandatory=$false)][bool]$isGitHubDirectoryUrl = $false
    )

    # connect to Azure
    if (!(Get-AzContext)){
      Connect-AzAccount -EnvironmentName AzureUSGovernment
      #Select-AzSubscription -Current -SubscriptionName Staging
    }

    # Check Existing Rules (don't create new ones for existing rules, this is a repo sync option)
    write-host "get existing alert rules ..." -ForegroundColor Green
    $existingRules = get-azsentinelalertrule -resourceGroupName $resourceGroupName -workspaceName $workspaceName

    # Set $existingRules to empty array if no rules are found
    if([string]::IsNullOrWhiteSpace($existingRules)){
      $existingRules = @()
    }

    if($isGitHubDirectoryUrl)
    {
        write-host "[`$isGitHubDirectoryUrl] was set to $true, getting all URLs on page ..." -ForegroundColor Green
        $gitDir = Invoke-WebRequest $gitHubRawUrl                                                                                               
        $gitRules = ($gitDir.Links.outerhtml | ?{$_ -like "*.yaml*"} | %{[regex]::match($_,'master.*yaml"').Value}).Replace('"',"") | %{if($_ -ne ""){"https://raw.githubusercontent.com/Azure/Azure-Sentinel/" + $_}}
        write-host "Found these rules on the page:" -ForegroundColor Green
        $gitRules
        # write all alert rules from github dir to sentinel
        foreach($rawLink in $gitRules)
        {
            New-SingleAlertRuleFromGitHub -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -gitHubRawUrl $rawLink -existingRules $existingRules
        }
    }
    else {
        # write alert rule to sentinel
        write-host "This is a single request for $gitHubRawUrl ..." -ForegroundColor Green
        New-SingleAlertRuleFromGitHub -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -gitHubRawUrl $gitHubRawUrl -existingRules $existingRules
    }
}

function New-SingleAlertRuleFromGitHub {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$resourceGroupName,
        [Parameter(Mandatory=$true)][string]$workspaceName,
        [Parameter(Mandatory=$true)][string]$gitHubRawUrl,
        [Parameter(Mandatory=$true)][AllowEmptyCollection()][array]$existingRules
    )

    # connect to gitHub and read raw yaml
    $yaml= convertfrom-yaml (Invoke-RestMethod $gitHubRawUrl)
    Write-Host "GH-RAW-URL: $gitHubRawUrl" -ForegroundColor Yellow
    # convert compare parameters
    $global:compHT = @{}
    $compHT.add("gt","GreaterThan")
    $compHT.add("eq","Equal")
    $compHT.add("lt","LessThan")
    $compHT.add("ne","NotEqual")

    try {
      # create timespans for queryperiod and queryfrequency
      write-host "create timespans for queryperiod and queryfrequency ..." -ForegroundColor Green
      if($yaml.QueryPeriod.contains("d"))
      {
          $QueryPeriod = New-TimeSpan -days $yaml.QueryPeriod.replace("d","")
      }
      if($yaml.queryFrequency.contains("d"))
      {
          $QueryFrequency = New-TimeSpan -days $yaml.queryFrequency.replace("d","")
      }
      if($yaml.QueryPeriod.contains("h"))
      {
          $QueryPeriod = New-TimeSpan -hours $yaml.QueryPeriod.replace("h","")
      }
      if($yaml.queryFrequency.contains("h"))
      {
          $QueryFrequency = New-TimeSpan -hours $yaml.queryFrequency.replace("h","")
      }
      # lookup compare parameter
      $cp = $compHT[$yaml.TriggerOperator]

      if($existingRules){
        if($existingRules.DisplayName -notcontains $yaml.name) {
            $rDisplayName = $yaml.name  
            write-host "creating new rule: $rDisplayName ..." -ForegroundColor Green
            $query = $yaml.Query
            $retval = New-AzSentinelAlertRule -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -Kind Scheduled -Enabled -description $yaml.description -DisplayName $yaml.name -Severity $yaml.Severity -Query $query -QueryFrequency $QueryFrequency -QueryPeriod $QueryPeriod -TriggerThreshold $yaml.TriggerThreshold -TriggerOperator $cp
            Write-Host "Rule created: [$rDisplayName]" -ForegroundColor Green
        } else {
            Write-Host "Skipping. Rule already exists." -ForegroundColor Yellow
        }
      }
    }
    catch {
      $errstr = $_.exception.message
      $tmpstr = "Error creating Azure Sentinal Alert Rule : $errstr"
      write-warning $tmpstr
    }
    
}