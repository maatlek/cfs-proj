vm=(webserver01 webserver02 jumpserver server11)

# creting a Public IP Address for Jump / Server11
az network public-ip create \
    --resource-group mknilavembu_rgsea \
    --name jump_pubip \
    --sku Standard

az network public-ip create \
    --resource-group mknilavembu_rgeus \
    --name server11_pubip \
    --sku Standard

# Creating NICs 
az network nic create \
    --resource-group mknilavembu_rgsea \
    --name "${vm[0]}-nic" \
    --vnet-name seavnet \
    --subnet sea_web_sub \
    --network-security-group sea_nsg
    --application-security-groups sea_web_asg

az network nic create \
    --resource-group mknilavembu_rgsea \
    --name "${vm[1]}-nic" \
    --vnet-name seavnet \
    --subnet sea_web_sub \
    --network-security-group sea_nsg
    --application-security-groups sea_web_asg

az network nic create \
    --resource-group mknilavembu_rgsea \
    --name "${vm[2]}-nic" \
    --vnet-name seavnet \
    --subnet sea_jump_sub \
    --network-security-group sea_nsg
    --public-ip-address jump_pubip
    --application-security-groups sea_jump_asg

az network nic create \
    --resource-group mknilavembu_rgeus \
    --name "${vm[3]}-nic" \
    --vnet-name eusvnet \
    --subnet eus_web_sub \
    --network-security-group eus_nsg
    --public-ip-address server11_pubip
    --application-security-groups eus_web_asg

## Adding NICs to Load Balancer

az network nic ip-config address-pool add \
    --address-pool lb_sea_bp \
    --ip-config-name ipconfig1 \
    --nic-name "${vm[0]}-nic" \
    --resource-group mknilavembu_rgsea \
    --lb-name lb_sea

az network nic ip-config address-pool add \
    --address-pool lb_sea_bp \
    --ip-config-name ipconfig1 \
    --nic-name "${vm[1]}-nic" \
    --resource-group mknilavembu_rgsea \
    --lb-name lb_sea

# Creating an Availability Set

az vm availability-set create -n sea_avs -g mknilavembu_rgsea \
    --platform-fault-domain-count 2 \
    --platform-update-domain-count 1

# Creating a Virtual Machine

az vm create \
    --resource-group mknilavembu_rgsea \
    --name ${vm[0]} \
    --nics "${vm[0]}-nic" \
    --image win2019datacenter \
    --admin-username mkadmin \
    --admin-password "Password@123"
    --availability-set sea_avs
    --no-wait

az vm create \
    --resource-group mknilavembu_rgsea \
    --name ${vm[1]} \
    --nics "${vm[1]}-nic" \
    --image win2019datacenter \
    --admin-username mkadmin \
    --admin-password "Password@123"
    --availability-set sea_avs
    --no-wait

az vm create \
    --resource-group mknilavembu_rgsea \
    --name ${vm[2]} \
    --nics "${vm[2]}-nic" \
    --image win2019datacenter \
    --admin-username mkadmin \
    --admin-password "Password@123"
    --no-wait

az vm create \
    --resource-group mknilavembu_rgsea \
    --name ${vm[3]} \
    --nics "${vm[3]}-nic" \
    --image win2019datacenter \
    --admin-username mkadmin \
    --admin-password "Password@123"
    --no-wait

