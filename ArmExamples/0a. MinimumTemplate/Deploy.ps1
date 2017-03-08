New-AzureRmResourceGroup -Name "minimumRG" -Location "west europe" -Force
New-AzureRmResourceGroupDeployment -ResourceGroupName "minimumRG" -TemplateFile ".\minimum.json"
Remove-AzureRmResourceGroup -Name "minimumRG" -Force 