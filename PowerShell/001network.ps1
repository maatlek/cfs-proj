# Creating a Virtual Network

## Creating Application Security Group

$asgs1 = New-AzApplicationSecurityGroup -ResourceGroupName $RG[0] -Name "sea-web-asg" -Location $location[0]
$asgs2 =  New-AzApplicationSecurityGroup -ResourceGroupName $RG[0] -Name "sea-jump-asg" -Location $location[0]

$asge = New-AzApplicationSecurityGroup -ResourceGroupName $RG[1] -Name "eus-web-asg" -Location $location[1]


## Configuring Rules for the network

### SEA Region
$Rule_sea_80443 = New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP_HTTPS" -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix * -SourcePortRange * -DestinationApplicationSecurityGroup $asgs1 -DestinationPortRange 80,443 -Priority 1000

$Rule_sea_3389 = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Priority 1100

$Rule_sea_21 = New-AzNetworkSecurityRuleConfig -Name "Allow-FTP-jump" -Direction Inbound -Access Allow -Protocol Tcp -SourceApplicationSecurityGroup $asgs2 -SourcePortRange * -DestinationApplicationSecurityGroup $asgs1 -DestinationPortRange 21 -Priority 1200


### EUS Region
$Rule_eus_80443 = New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP_HTTPS" -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix * -SourcePortRange * -DestinationApplicationSecurityGroup $asge -DestinationPortRange 80,443 -Priority 1000

$Rule_eus_3389 = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Priority 1100


## Creating Network Security Group

$sea_nsg = New-AzNetworkSecurityGroup -ResourceGroupName $RG[0] -Location $location[0] -Name "sea-nsg" -SecurityRules $Rule_sea_80443,$Rule_sea_3389,$Rule_sea_21

$eus_nsg = New-AzNetworkSecurityGroup -ResourceGroupName $RG[1] -Location $location[1] -Name "eus-nsg" -SecurityRules $Rule_eus_80443,$Rule_eus_3389


## Creating a Subnet

$sea_websub = New-AzVirtualNetworkSubnetConfig -Name "sea-web-subnet" -AddressPrefix "10.1.0.0/24" -NetworkSecurityGroup $sea_nsg

$sea_jumpsub = New-AzVirtualNetworkSubnetConfig -Name "sea-jump-subnet" -AddressPrefix "10.2.0.0/24" -NetworkSecurityGroup $sea_nsg

$eus_websub = New-AzVirtualNetworkSubnetConfig -Name "eus-web-subnet" -AddressPrefix "192.168.0.0/24" -NetworkSecurityGroup $eus_nsg


## Adding Subnets to a Virtual Network

$sea_vnet = New-AzVirtualNetwork -Name "sea-vnet" -ResourceGroupName $RG[0] -Location $location[0] -AddressPrefix "10.0.0.0/8"-Subnet $sea_websub,$sea_jumpsub

$eus_vnet = New-AzVirtualNetwork -Name "sea-vnet" -ResourceGroupName $RG[1] -Location $location[1] -AddressPrefix "192.168.0.0/16"-Subnet $eus_websub


## Adding a Virual Network Peering

Add-AzVirtualNetworkPeering -Name 'eus-sea' -VirtualNetwork $eus_vnet -RemoteVirtualNetworkId $sea_vnet.Id

Add-AzVirtualNetworkPeering -Name 'sea-eus' -VirtualNetwork $sea_vnet -RemoteVirtualNetworkId $eus_vnet.Id


