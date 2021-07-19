# Creating a Network Components

## Creating an Application Security Group

az network asg create -g ${rg[0]} -n sea_web_asg

az network asg create -g ${rg[0]} -n sea_jump_asg

az network asg create -g ${rg[1]} -n eus_web_asg

## Creating a Network Security Group

az network nsg create -g ${rg[0]} -n sea_nsg
az network nsg create -g ${rg[1]} -n eus_nsg

## Configuring Network Rules

az network nsg rule create -g ${rg[0]} --nsg-name sea_nsg \
    -n rule_80443 \
    --priority 4096 \
    --source-address-prefixes '*' \
    --source-port-ranges '*' \
    --destination-asgs sea_web_asg \
    --destination-port-ranges 80 443 \
    --access Allow \
    --protocol Tcp

az network nsg rule create -g ${rg[0]} --nsg-name sea_nsg \
    -n rule_3389 \
    --priority 4090 \
    --source-address-prefixes '*' \
    --source-port-ranges '*' \
    --destination-address-prefixes '*' \
    --destination-port-ranges 3389 \
    --access Allow \
    --protocol Tcp

az network nsg rule create -g ${rg[0]} --nsg-name sea_nsg \
    -n rule_3389 \
    --priority 4090 \
    --source-asgs sea_jump_asg \
    --source-port-ranges '*' \
    --destination-asgs sea_web_asg \
    --destination-port-ranges 21 \
    --access Allow \
    --protocol Tcp

az network nsg rule create -g ${rg[1]} --nsg-name eus_nsg \
    -n rule_80443 \
    --priority 4096 \
    --source-address-prefixes '*' \
    --source-port-ranges '*' \
    --destination-asgs eus_web_asg \
    --destination-port-ranges 80 443 \
    --access Allow \
    --protocol Tcp

# Creating a vnet

az network vnet create -g ${rg[0]} -n seavnet \
    --address-prefix 10.0.0.0/8

az network vnet create -g ${rg[1]} -n eusvnet \
    --address-prefix 192.168.0.0/16

## Creating a Subnet

az network vnet subnet create -g mknilavembu_rgsea \
    --vnet-name seavnet -n sea_web_sub \
    --address-prefixes 10.1.0.0/24 \
    --network-security-group sea_nsg

az network vnet subnet create -g mknilavembu_rgsea \
    --vnet-name seavnet -n sea_jump_sub \
    --address-prefixes 10.1.0.0/24 \
    --network-security-group sea_nsg

az network vnet subnet create -g mknilavembu_rgeus \
    --vnet-name seavnet -n sea_web_sub \
    --address-prefixes 192.168.0.0/24 \
    --network-security-group eus_nsg