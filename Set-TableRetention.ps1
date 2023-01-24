# Get tables in var
$Tables = Import-Csv ./tableList.csv

$s = "vog-mgmt"
$rg = "v1-prod-va-mp-core-rg"
$ws = "v1-prod-va-mp-la-1"

foreach ($t in $Tables) {
    az monitor log-analytics workspace table update --subscription $s --resource-group $rg --workspace-name $ws --name $t.tablename --retention-time 90 --total-retention-time 366
}
