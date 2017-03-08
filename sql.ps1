# Authenticate
Login-AzureRmAccount

# Create a resource group for this demo
$myRg = New-AzureRmResourceGroup -Name "AzureSqlLab" -Location "West Europe"

# Create a Azure SQL Server, you will be asked to enter a username and password for the admin account
$dbservername = "nordineserver12"
New-AzureRmSqlServer -ResourceGroupName $myRg.ResourceGroupName `
 -ServerName $dbservername -Location "West Europe" -ServerVersion "12.0"

# Specify the IP addresses that can connect to the server 
New-AzureRmSqlServerFirewallRule -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername -FirewallRuleName "clientFirewallRule1" -StartIpAddress "192.168.0.198" -EndIpAddress "192.168.0.199"

# create a database
New-AzureRmSqlDatabase -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername -DatabaseName "TestDB12" -Edition Standard -RequestedServiceObjectiveName "S1"

# scale up the database
Set-AzureRmSqlDatabase -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername -DatabaseName "TestDB12" -Edition Standard -RequestedServiceObjectiveName "S2"

# remove the database
Remove-AzureRmSqlDatabase -ResourceGroupName $myRg.ResourceGroupName `
-ServerName $dbservername -DatabaseName "TestDB12"

# remove the resource group
Remove-AzureRmSqlServer -ResourceGroupName $myRg.ResourceGroupName `
    -ServerName $dbservername




Remove-AzureRmResourceGroup -Name $myRg.ResourceGroupName -Force 
