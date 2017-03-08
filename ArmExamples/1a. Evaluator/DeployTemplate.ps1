$resourceGroupName = "evaluatorRG"
$location = "west europe"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

$output = New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile '.\add.json'

Write-host $output.Parameters["first"].Value '+' $output.Parameters["second"].Value '=' $output.Outputs["addResult"].Value 

Remove-AzureRmResourceGroup -Force -Name $resourceGroupName 
