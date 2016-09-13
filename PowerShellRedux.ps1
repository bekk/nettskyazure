
#region My PowerShell Preferences

# Via PowerShell Gallery
 
#Requires -version 3.0
Set-StrictMode -Version 3

# avoid F5
Break

#import azure stuff
Import-Module Azure 

# presentation mode
$psISE.Options.Zoom = 150 

# check version
$PSVersionTable

# Stop on error
$ErrorActionPreference = "Stop"

#  all scripts downloaded from the Internet must be signed by a trusted publisher
Set-ExecutionPolicy RemoteSigned

# Shift + Alt + Up/Down


#endregion

#region Define Constant in PowerShell
if ($(Get-Variable EmailAddress -Scope Global -ErrorAction SilentlyContinue) -eq $null)
{
    New-Variable `
        -Name EmailAddress `
        -Value 'nordine@live.no' `
        -Option Constant `
        -Visibility Public `

    Write-Host "Constant EmailAddress has been set to $EmailAddress"
}
#endregion

#region Azure Login ASM

# automatically generate a management certificate for
# each subscription where you are admin/co-admin
Get-AzurePublishSettingsFile 

# Edit the XML if needed
Import-AzurePublishSettingsFile -PublishSettingsFile C:\creds.publishsettings

# Best Practice
Remove-Item C:\creds.publishsettings

# Invoke-Item
ii $env:APPDATA\"Windows Azure Powershell"

# Check MMC > Certificates

Get-AzureAccount
Get-AzureSubscription
Get-AzureRmSubscription

#endregion

#region Azure Login (ARM)

#
# Login-AzureRmAccount is only for Azure Resource Manager (AzureRM* modules).
#

$logincontext = Get-AzureRmContext -ErrorAction SilentlyContinue 
if ( $logincontext -eq $null) 
{
  # Can you use -Credential?
  Login-AzureRmAccount 

  # Now we are logged in for 12 hours
  $logincontext = Get-AzureRmContext -ErrorAction Continue
  
  # The context is per session, so as soon as your PS session is over, 
  # the context is killed (equivalent of Remove-AzureAccount). 
}

Get-AzureRmSubscription `
    | Where-Object {$_.State -eq 'Enabled' } `
    | select-Object @{Name="NAME"; Expression={$_.SubscriptionName.ToUpper()}}

Get-AzureRmSubscription `
    | Where State -eq "Enabled"  `
    | %{ Write-Host "Log: $_" -ForegroundColor Green; $_ } `
    | Select SubscriptionName | Out-String

Get-AzureRmSubscription | Out-GridView

Get-AzureLocation | Out-GridView

# What about Get-AzureSubscription and Set-AzureSubscription
Select-AzureRmSubscription -SubscriptionName "Nettskyprogrammet" 

# Tips:
write-host $logincontext
$logincontext | Out-String
$logincontext

#endregion 



# create a unique name based on the email address
$tmp = $([regex ]::Replace($email , "[^0-9a-zA-Z]+" , "" ))
if ($tmp.Length>16)
{
$tmp = $tmp.Substring(16)
}

# Create a resource group
#    Try to run the command twice
$myRg = New-AzureRmResourceGroup `
    -Name "$($tmp)RG" `
    -Location "North Europe" 

# Create a storage account in our resource group 
#   - Storage account name must be in LOWERCASE
$myStorageAccount = New-AzureRmStorageAccount `
    -Name "$($tmp)ST".ToLowerInvariant() `
    -Type Standard_LRS `
    -Location "West Europe" `
    -ResourceGroupName $myRG.ResourceGroupName `

# Set the storage as default for the subscription
Set-AzureRmCurrentStorageAccount  -StorageAccountName $myStorageAccount.StorageAccountName  -ResourceGroupName $myStorageAccount.ResourceGroupName

# Now check the default storage
Select-AzureRmSubscription -SubscriptionName "Nettskyprogrammet" 

# Delete the Resource Group 
Remove-AzureRmResourceGroup -Name $myRg.ResourceGroupName


Set-AzureRmStorageAccount -name "nordine" -Type Standard_LRS  -ResourceGroupName $myRg.ResourceGroupName
Select-AzureRmSubscription -

New-AzureStorageContainer -

#Notice you don't always get parameters completion (e.g. location)
$myStorage = New-AzureRmStorageAccount ` 
 -Name $tmp  -Type Standard_LRS ` 
 -Location "West Europe" ` 
 -ResourceGroupName $myRg.ResourceGroupName ` 
 -Tags @( @{ Name ="owner"; Value ="$myemail " }) 

#$myStorage | Remove-AzureRmStorageAccount
Remove-AzureRmStorageAccount -Name  $myStorage.StorageAccountName -ResourceGroupName $myRg .ResourceGroupName 

#this is the first and last time you should be using affinity groups
New-AzureAffinityGroup -Name $tmp  -Location "North Europe" -Label "Scandinavia Region" -Description "Affinity group for Scandinavians only!" 
New-AzureStorageAccount -StorageAccountName $tmp -AffinityGroup 


# What does this command?
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob | Remove-AzureStorageBlob

$PSVersionTable | Get-Member | clip 