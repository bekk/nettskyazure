#Create AzureDNSZone
```
$subscription="SUBSCRIPTIONID"
$location="West Europe"
$domainName = "xyz.com"
$resourceGroupName="xyzDNS"
Login-AzureRmAccount
Select-AzureRmSubscription -Subscriptionid $subscription
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.Network
New-AzureRmDnsZone -Name $domainName -ResourceGroupName $resourceGroupName -Tag @( @{ Name="owner"; Value="nordine ben bachir" }, @{ Name="testkey"; Value="testvalue" } )
Get-AzureRmDnsRecordSet -ZoneName $domainname -ResourceGroupName $resourceGroupName -ErrorAction Continue
```

#Create a wildcard record
```
$subscription="SUBSCRIPTIONID"
$domainName = "xyz.com"
$resourceGroupName="xyzDNS"
$recordToCreate="*"
$ip="127.0.0.1"
Login-AzureRmAccount
Select-AzureRmSubscription -Subscriptionid $subscription
$zone = Get-AzureRmDnsZone –Name $domainName –ResourceGroupName $resourceGroupName
$rs = New-AzureRmDnsRecordSet -Name $recordToCreate -RecordType A -Zone $zone -Ttl 60
add-AzureRmDnsRecordConfig -RecordSet $rs -Ipv4Address $ip
Set-AzureRmDnsRecordSet -RecordSet $rs -Overwrite
```
#Delete a record
```
$subscription="SUBSCRIPTIONID"
$domainName = "xyz.com"
$resourceGroupName="xyzDNS"
$recordToDelete="*"
Login-AzureRmAccount
Select-AzureRmSubscription -Subscriptionid $subscription
$zone = Get-AzureRmDnsZone –Name $domainName –ResourceGroupName $resourceGroupName
$RecordSet = Get-AzureRmDnsRecordSet -Name $recordToDelete -RecordType A -Zone $zone
Remove-AzureRmDnsRecordSet -RecordSet $RecordSet
Get-AzureRmDnsRecordSet -ZoneName $domainname -ResourceGroupName $resourceGroupName -ErrorAction Continue
Delete AzureDNSZone
$subscription="SUBSCRIPTIONID"
$domainName = "xyz.com"
$resourceGroupName="xyzDNS"
```

#Cleanup
```
Login-AzureRmAccount
Select-AzureRmSubscription -Subscriptionid $subscription
Remove-AzureRmDnsZone -Name $domainName -ResourceGroupName $resourceGroupName
```
