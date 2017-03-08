New-AzureRmResourceGroup   `-Name "minimumRG"  -Location 'west europe' 
New-AzureRmResourceGroupDeployment `-ResourceGroupName $resourceGroupName -TemplateFile  '.\azuredeploy.json' 
Remove-AzureRmResourceGroup -Force -Name $resourceGroupName 