# Creating a Load Balancer

## Creating a Public IP Address

az network public-ip create \
    --resource-group mknilavembu_rgsea \
    --name lb_pubip \
    --sku Standard

## Creating the load balancer

az network lb create \
    --resource-group mknilavembu_rgsea \
    --name lb_sea \
    --sku Standard \
    --public-ip-address lb_sea_pubip \
    --frontend-ip-name lb_sea_feip \
    --backend-pool-name lb_sea_bp

## Creating an Health Probe

az network lb probe create \
    --resource-group mknilavembu_rgsea \
    --lb-name myLoadBalancer \
    --name lb_sea_probe1 \
    --protocol tcp \
    --port 80
    --interval 60
    --threshold 3

## Creating an Rule for LB

az network lb rule create \
    --resource-group mknilavembu_rgsea \
    --lb-name lb_sea \
    --name HTTP \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name lb_sea_feip \
    --backend-pool-name lb_sea_bp \
    --probe-name lb_sea_probe1 \
    --disable-outbound-snat true \
    --idle-timeout 5 \
    --enable-tcp-reset true
    --load-distribution SourceIPProtocol

## Creating a Front End IP for Load Balancer

az network lb frontend-ip create \
    --resource-group mknilavembu_rgsea \
    --name lb_sea_feip \
    --lb-name lb_sea \
    --public-ip-address lb_pubip

## Creating an Inbound NAT Rule
az network lb inbound-nat-rule create -g mknilavembu_rgsea \
    --lb-name lb_sea -n RDPsession \
    --protocol Tcp --frontend-port 80\
    --backend-port 3389
