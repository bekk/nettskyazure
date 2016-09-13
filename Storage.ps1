
# Login and select the subscription Nettskyprogrammet
#
$myRgName = "nordineRG"
$myStorageName = "nordinest"
$myContainer = "temp"

# Create a resource group
$myRg = New-AzureRmResourceGroup -Name $myRgName -Location "North Europe" 

# Create a LRS storage
$myStorageAccount = New-AzureRmStorageAccount `
    -Name $myStorageName `
    -Type Standard_LRS `
    -Location "North Europe" `
    -ResourceGroupName $myRG.ResourceGroupName `

# Create a PUBLIC container
New-AzureStorageContainer -Context $myStorageAccount.Context `
    -Name $myContainer -Permission Container 
    
# Run this command multiple times
#     - What happens?
Set-AzureStorageBlobContent `
    -Container $myContainer `
    -Context  $myStorageAccount.Context  `
    -BlobType Block  `
    -file "c:\windows\windowsupdate.log"

# What does this one do?
$blob = Set-AzureStorageBlobContent `
    -Blob "/this/is/my/file.log" `
    -Properties @{"CacheControl" = "private, max-age=1"; "ContentType"="text/plain"} `
    -Container $myContainer `
    -Context  $myStorageAccount.Context  `
    -BlobType Block  `
    -file "c:\windows\windowsupdate.log" `    -Metadata  @{"owner"="nordine"}

# Download the blob using HTTP
$blob = Get-AzureStorageBlob -Context $myStorageAccount.Context `  -Container $myContainer -Blob $blob.Name 
$downloaded = Invoke-WebRequest -Uri $blob.ICloudBlob.Uri.AbsoluteUri -UseBasicParsing

# Look at the headers, what do you see?
$downloaded.Headers

# Set the container PRIVATE
Set-AzureStorageContainerAcl -Name $myContainer -Context $myStorageAccount.Context -Permission Off

# Try to download again...
$downloaded = Invoke-WebRequest -Uri $uri -UseBasicParsing

# Delete the Resource Group 
Remove-AzureRmResourceGroup -Name $myRg.ResourceGroupName


Get-AzureStorageBlob -Context $myStorageAccount.Context -Container $myContainer

Remove-AzureStorageBlob -Context $myStorageAccount.Context -Container $myContainer -Blob "myfile"

Get-AzureStorageBlob -Context $myStorageAccount.Context -Container $myContainer




Set-AzureStorageContainerAcl -Name $myContainer -Context $myStorageAccount.Context -Permission Off
#
# 1. Unique policy name suffixed with current timestamp
# 2. With expiry date in 2 weeks
# 3. With permissions to Read, Write, Delete and List
#
$policyName = ('saspolicy' + [DateTime]::Now.ToString('s').Replace(":","").Replace("-","")).ToLower()
$expiryTime = (get-date).AddDays(14)
$permission = "rwdl"

New-AzureStorageContainerStoredAccessPolicy `
    -Container $myContainer `
    -Policy $policyName `
    -Permission $permission `
    -ExpiryTime $expiryTime `
    -Context $myStorageAccount.Context

$policies = Get-AzureStorageContainerStoredAccessPolicy -Container $myContainer -Context  $myStorageAccount.Context
$policies

$sas1 = New-AzureStorageContainerSASToken  `    -Name $myContainer `
    -Policy  $policyName `
    -ExpiryTime (get-date).AddMinutes(2) -FullUri
    

$sas2 = New-AzureStorageContainerSASToken -Context `    -Name $myContainer `
    -Permission rwdl `
    -ExpiryTime (get-date).AddDays(1)

$myStorageName = "nordinest"
$sasContext = New-AzureStorageContext -SasToken $sas2 -StorageAccountName $myStorageName -Debug
Get-AzureStorageBlob -Context $sasContext -Container $myContainer




$secureuri = $uri + $sas2
$downloaded = Invoke-WebRequest -Uri $secureuri -UseBasicParsing 
$downloaded.Headers

# -  -Name $ContainerName -Permission rwl -Context $context -ExpiryTime (get-date).AddDays(3650)

# Create a SAS token for the storage container - this gives temporary read-only access to the container (defaults to 1 hour).
#$dropLocationSasToken = New-AzureStorageContainerSASToken -Container $StorageContainerName -Context $storageAccountContext -Permission r 
#$dropLocationSasToken = ConvertTo-SecureString $dropLocationSasToken -AsPlainText -Force