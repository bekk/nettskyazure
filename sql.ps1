
#region Create SQL Azure Server
$dbservername = "nordineserver12"
New-AzureRmSqlServer -ResourceGroupName $myRg.ResourceGroupName `
 -ServerName $dbservername -Location "North Europe" -ServerVersion "12.0"

New-AzureRmSqlServerFirewallRule -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername -FirewallRuleName "clientFirewallRule1" -StartIpAddress "192.168.0.198" -EndIpAddress "192.168.0.199"

New-AzureRmSqlDatabase -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername -DatabaseName "TestDB12" -Edition Standard -RequestedServiceObjectiveName "S1"

Set-AzureRmSqlDatabase -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername -DatabaseName "TestDB12" -Edition Standard -RequestedServiceObjectiveName "S2"


Remove-AzureRmSqlDatabase -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername -DatabaseName "TestDB12"

Remove-AzureRmSqlServer -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername
#endregion