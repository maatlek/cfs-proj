#!bin/bash

# Update Package repo
sudo apt-get update

# Installation on Debian
sudo apt-get install azure-cli

# Installation on Cent OS, RHEL
sudo yum install azure-cli

# Connect
az login

## Creating a Resource Group
rg=("mknilavembu_rgsea" "mknilavembu_rgeus")
location=("australiaeast" "canadacentral")

az group create --location ${location[0]} --name ${rg[0]} \
    --tags business=nilavembu, location=southeastasia 

az group create --location ${location[1]} --name ${rg[1]} \
    --tags business=nilavembu, location=canadacentral 



