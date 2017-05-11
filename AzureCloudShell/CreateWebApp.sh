gitrepo=https://github.com/Azure-Samples/app-service-web-dotnet-get-started.git
resourcegroupname=NordineRSG
webappname=nordinewebapp
serviceplan=nordineplan

az group create --location westeurope --name $resourcegroupname
az appservice plan create --name $nordineplan --resource-group $resourcegroupname --sku FREE
az webapp create --name $webappname --resource-group $resourcegroupname --plan $serviceplan
az webapp deployment source config --name $webappname --resource-group $resourcegroupname --repo-url $gitrepo --branch master --manual-integration
#az group delete --name $resourcegroupname --no-wait --yes
