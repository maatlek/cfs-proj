# Creating backup for SEA Webserver

az backup vault create --resource-group mknilavembu_rgsea \
    --name sea_rgbkp_vault \
    --location australiaeast

az backup protection enable-for-vm \
    --resource-group mknilavembu_rgsea \
    --vault-name sea_rgbkp_vault \
    --vm ${vm[0]} \
    --policy-name DefaultPolicy

az backup protection enable-for-vm \
    --resource-group mknilavembu_rgsea \
    --vault-name sea_rgbkp_vault \
    --vm ${vm[1]} \
    --policy-name DefaultPolicy