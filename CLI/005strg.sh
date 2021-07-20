# Creating a Storage Account

az storage account create -n nilstorage_sea01 \
 -g mknilavembu_rgsea -l australiaeast \
 --sku Standard_ZRS \
 --kind BlobStorage

az storage account create -n nilstorage_eus01 \
 -g mknilavembu_rgeus -l canadacentral \
 --sku Standard_GRS
 --kind BlobStorage

## Creating a container

az storage container create -n nilstorage_sea01 \
    --public-access blob

az storage container create -n nilstorage_eus01 \
    --public-access blob

### Creating a SAS Container

az storage container generate-sas --account-name nilstorage_sea01 \
    --as-user --auth-mode login \
    --expiry 2022-01-01 \
    --name sales_con_sea --permissions dlrw | xargs echo "Sas Acount Key SEA Region" > sas.txt

az storage container generate-sas --account-name nilstorage_eus01 \
    --as-user --auth-mode login \
    --expiry 2022-01-01 \
    --name sales_con_sea --permissions dlrw | xargs echo "Sas Acount Key EUS Region" >> sas.txt

## Storage Share

az storage share create --account-name nilstorage_sea01 \
    --name sales_share
    --quota 1

az storage share create --account-name nilstorage_eus01 \
    --name sales_share
    --quota 1