# Azure Cloud Shell Introduction

##Bash features:
+ tab completion
+ uname -a
+ history
+ wget / curl
+ pip install haxor-news --user  && ~/.local/bin/hn top

Check your storage: cloud-shell-storage-westeurope > csb9539bc248692x4fe2x871 > Files 

The default output format of the CLI is JSON, but tou can change it per-command with --out table or using az configure. 

Examples
+ az group list
+ az vm list --out table
+ az configure

## Create A Web application from inside the cloud shell
https://github.com/bekk/nettskyazure/tree/master/AzureCloudShell



## Running a Gist directly from the Cloud Shell (Bash)

```bash
script="`wget -O - https://raw.githubusercontent.com/bekk/nettskyazure/master/AzureCloudShell/CreateWebApp.sh`"

echo "$script"

eval "$script"
```
