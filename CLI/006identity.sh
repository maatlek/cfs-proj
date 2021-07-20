# Creating User Account

domain=mkadminoutlook@onmicrosoft.com

az ad user create --display-name vmadmin
                  --password "CfsPassword@123"
                  --user-principal-name "vmadmin${domain}"
                  --force-change-password-next-login false

az role assignment create --assignee "vmadmin${domain}" \
    --role "Virtual Machine Contributor" \
    --scope "/subscriptions/7e970a5a-ab04-4b97-bc65-0b1e079a1ad9/"

az ad user create --display-name bkpadmin
                  --password "CfsPassword@123"
                  --user-principal-name "bkpadmin${domain}"
                  --force-change-password-next-login false

az role assignment create --assignee "bkpadmin${domain}" \
    --role "Backup Contributor" \
    --scope "/subscriptions/7e970a5a-ab04-4b97-bc65-0b1e079a1ad9/resourceGroups/Nilavembu_EUS/providers/Microsoft.Compute/virtualMachines/"