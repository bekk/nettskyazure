# Azure Resource Policies

Azure Resource Policies make sure that resources are placed in the correct resource groups, in the correct region or that all the provisioned resources are correctly named and tagged. Per resource group or Per Subscription

# Using the portal

+ Create a Resource Group
+ Select Policies > Add 
+ Create a Policy that denies all deployments outside of North Europe
+ Try to create a storage in West Europe 

# Create a custom policy

```bash
script="`wget -O - https://raw.githubusercontent.com/bekk/nettskyazure/master/Azure-Policies/location-policy.json`"
az policy definition create --name NorPol --rules "$script"
```

# Assign a policy

```bash
$subscriptionid=""
$targetresourcegroupname=""                           
az policy assignment create --name NorPolAssignment --policy NorPolDef --scope /subscriptions/$subscriptionid/resourceGroups/$targetresourcegroupname
```
