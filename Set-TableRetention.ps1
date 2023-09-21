# Get tables in var
$Tables = Import-Csv ./tableList.csv

$sub = "0000-0000-0000-0000"
$rg = "va-mp-core-rg"
$ws = "va-mp-la-1"

foreach ($t in $Tables) {
    az monitor log-analytics workspace table update --subscription $sub --resource-group $rg --workspace-name $ws --name $t.tablename --retention-time 90 --total-retention-time 366
}
