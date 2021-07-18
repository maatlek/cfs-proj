Creating the Case Study with PowerShell

# Intial Configuration
Commands refer to [Pre-Requisite](./000prerequisite.ps1)
```powershell

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Set-ExecutionPolicy Unrestricted

Update-Module

Install-Module az

Connect-AzAccount

```

After the inital configuration is done and connected to a tenant. Verifiying it can be done by :

```powershell
PS > Get-AzTenant

Id                                   Name              Category Domains
--                                   ----              -------- -------
e50404b4-45b1-4e2a-845d-1f2385fdcf7f Default Directory Home     mehervalluri5outlook.onmicrosoft.com
```

# Creating a Resource Group

```powershell
New-AzResourceGroup -Name Nilavembu_SEA -Tag @{Business = "Nilavembu"} -Location "Australia East"

New-AzResourceGroup -Name Nilavembu_EUS -Tag @{RgOwn = "Nilavembu"} -Location "Canada Central"
```

Once Resource Group is created we do a top layer aproach creating independent resources to dependent resources.

Output:
```output
ResourceGroupName : Nilavembu_SEA
Location          : australiaeast
ProvisioningState : Succeeded
Tags              :
                    Name      Value
                    ========  =========
                    Business  Nilavembu

ResourceId        : /subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA


ResourceGroupName : Nilavembu_EUS
Location          : canadacentral
ProvisioningState : Succeeded
Tags              :
                    Name      Value
                    ========  =========
                    Business  Nilavembu

ResourceId        : /subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_EUS
```

# Creating a Virtual Network
Commands refering from [Network](./001network.ps1)

Following Steps are followed for the same:
- Creating Application Security Group
- Configuring Rules for the network for both the region
- Creating a Network Security Group with added Rules
- Creating a Subnet
- Creating a Virtual Network

At Final, we creat a Virtual Network Peering from one vnet to another vnet. Below is the final output
```powershell
PS > Add-AzVirtualNetworkPeering -Name 'eus-sea' -VirtualNetwork $eus_vnet -RemoteVirtualNetworkId $sea_vnet.Id


Name                             : eus-sea
Id                               : /subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_EUS/providers/Microsoft.Network/virtualNetworks/sea-vnet/vi
                                   rtualNetworkPeerings/eus-sea
Etag                             : W/"b07895a7-10c5-482c-aa0d-31ff5d3ca0ad"
ResourceGroupName                : Nilavembu_EUS
VirtualNetworkName               : sea-vnet
PeeringSyncLevel                 : RemoteNotInSync
PeeringState                     : Initiated
ProvisioningState                : Succeeded
RemoteVirtualNetwork             : {
                                     "Id":
                                   "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/virtualNetworks/sea-vnet"
                                   }
AllowVirtualNetworkAccess        : True
AllowForwardedTraffic            : False
AllowGatewayTransit              : False
UseRemoteGateways                : False
RemoteGateways                   : null
PeeredRemoteAddressSpace         : {
                                     "AddressPrefixes": [
                                       "10.0.0.0/8"
                                     ]
                                   }
RemoteVirtualNetworkAddressSpace : {
                                     "AddressPrefixes": [
                                       "10.0.0.0/8"
                                     ]
                                   }


PS > Add-AzVirtualNetworkPeering -Name 'sea-eus' -VirtualNetwork $sea_vnet -RemoteVirtualNetworkId $eus_vnet.Id

Name                             : sea-eus
Id                               : /subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/virtualNetworks/sea-vnet/vi
                                   rtualNetworkPeerings/sea-eus
Etag                             : W/"922a6fce-b0af-4e4d-b37a-c6e1266e3028"
ResourceGroupName                : Nilavembu_SEA
VirtualNetworkName               : sea-vnet
PeeringSyncLevel                 : FullyInSync
PeeringState                     : Connected
ProvisioningState                : Succeeded
RemoteVirtualNetwork             : {
                                     "Id":
                                   "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_EUS/providers/Microsoft.Network/virtualNetworks/sea-vnet"
                                   }
AllowVirtualNetworkAccess        : True
AllowForwardedTraffic            : False
AllowGatewayTransit              : False
UseRemoteGateways                : False
RemoteGateways                   : null
PeeredRemoteAddressSpace         : {
                                     "AddressPrefixes": [
                                       "192.168.0.0/16"
                                     ]
                                   }
RemoteVirtualNetworkAddressSpace : {
                                     "AddressPrefixes": [
                                       "192.168.0.0/16"
                                     ]
                                   }

```

  
# Creating a Load Balancer
Commands refering from [Load Balancer](./002loadbalancer.ps1)

A Load Balancer is created for SEA Region for 2 webservers. Below Process is followed:
- Creating a Public IP
- Associating the Public IP with Load Balancer Front-End IP
- Creating a Back End Pool
- Creating Health Probe, to check on the Backend Pool
- Creating a Load Balancer Rule to allow only required protocol
- Finally creating a Load Balancer Resource

Below is the output:

```powershell

Name                     : sea-lb
ResourceGroupName        : Nilavembu_SEA
Location                 : australiaeast
Id                       : /subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb
Etag                     : W/"69440802-45dc-47f8-851c-dcb2b83a3b3a"
ResourceGuid             : 675b64f9-f3a4-44b6-9116-815598d3c6e1
ProvisioningState        : Succeeded
Tags                     :
FrontendIpConfigurations : [
                             {
                               "Name": "LoadBalancerFrontEnd",
                               "Etag": "W/\"69440802-45dc-47f8-851c-dcb2b83a3b3a\"",
                               "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/fro
                           ntendIPConfigurations/LoadBalancerFrontEnd",
                               "PrivateIpAllocationMethod": "Dynamic",
                               "ProvisioningState": "Succeeded",
                               "Zones": [],
                               "InboundNatRules": [],
                               "InboundNatPools": [],
                               "OutboundRules": [],
                               "LoadBalancingRules": [
                                 {
                                   "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb
                           /loadBalancingRules/Allow_HTTP"
                                 },
                                 {
                                   "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb
                           /loadBalancingRules/Allow_HTTPS"
                                 }
                               ],
                               "PublicIpAddress": {
                                 "IpTags": [],
                                 "Zones": [],
                                 "Id":
                           "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/publicIPAddresses/sea-lb-ip"
                               }
                             }
                           ]
BackendAddressPools      : [
                             {
                               "Name": "sea-lb-bp",
                               "Etag": "W/\"69440802-45dc-47f8-851c-dcb2b83a3b3a\"",
                               "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/bac
                           kendAddressPools/sea-lb-bp",
                               "ProvisioningState": "Succeeded",
                               "BackendIpConfigurations": [],
                               "LoadBalancerBackendAddresses": [],
                               "LoadBalancingRules": [
                                 {
                                   "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb
                           /loadBalancingRules/Allow_HTTP"
                                 },
                                 {
                                   "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb
                           /loadBalancingRules/Allow_HTTPS"
                                 }
                               ],
                               "TunnelInterfaces": []
                             }
                           ]
LoadBalancingRules       : [
                             {
                               "Name": "Allow_HTTP",
                               "Etag": "W/\"69440802-45dc-47f8-851c-dcb2b83a3b3a\"",
                               "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/loa
                           dBalancingRules/Allow_HTTP",
                               "Protocol": "Tcp",
                               "LoadDistribution": "Default",
                               "FrontendPort": 80,
                               "BackendPort": 80,
                               "IdleTimeoutInMinutes": 15,
                               "EnableFloatingIP": false,
                               "EnableTcpReset": false,
                               "DisableOutboundSNAT": false,
                               "ProvisioningState": "Succeeded",
                               "FrontendIPConfiguration": {
                                 "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/f
                           rontendIPConfigurations/LoadBalancerFrontEnd"
                               },
                               "BackendAddressPool": {
                                 "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/b
                           ackendAddressPools/sea-lb-bp"
                               },
                               "BackendAddressPools": [
                                 {
                                   "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb
                           /backendAddressPools/sea-lb-bp"
                                 }
                               ]
                             },
                             {
                               "Name": "Allow_HTTPS",
                               "Etag": "W/\"69440802-45dc-47f8-851c-dcb2b83a3b3a\"",
                               "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/loa
                           dBalancingRules/Allow_HTTPS",
                               "Protocol": "Tcp",
                               "LoadDistribution": "Default",
                               "FrontendPort": 443,
                               "BackendPort": 443,
                               "IdleTimeoutInMinutes": 15,
                               "EnableFloatingIP": false,
                               "EnableTcpReset": false,
                               "DisableOutboundSNAT": false,
                               "ProvisioningState": "Succeeded",
                               "FrontendIPConfiguration": {
                                 "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/f
                           rontendIPConfigurations/LoadBalancerFrontEnd"
                               },
                               "BackendAddressPool": {
                                 "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/b
                           ackendAddressPools/sea-lb-bp"
                               },
                               "BackendAddressPools": [
                                 {
                                   "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb
                           /backendAddressPools/sea-lb-bp"
                                 }
                               ]
                             }
                           ]
Probes                   : [
                             {
                               "Name": "webserver-health",
                               "Etag": "W/\"69440802-45dc-47f8-851c-dcb2b83a3b3a\"",
                               "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/pro
                           bes/webserver-health",
                               "Protocol": "Http",
                               "Port": 80,
                               "IntervalInSeconds": 360,
                               "NumberOfProbes": 5,
                               "RequestPath": "/",
                               "ProvisioningState": "Succeeded",
                               "LoadBalancingRules": []
                             },
                             {
                               "Name": "webserver-health-s",
                               "Etag": "W/\"69440802-45dc-47f8-851c-dcb2b83a3b3a\"",
                               "Id": "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Network/loadBalancers/sea-lb/pro
                           bes/webserver-health-s",
                               "Protocol": "Https",
                               "Port": 443,
                               "IntervalInSeconds": 360,
                               "NumberOfProbes": 5,
                               "RequestPath": "/",
                               "ProvisioningState": "Succeeded",
                               "LoadBalancingRules": []
                             }
                           ]
InboundNatRules          : []
InboundNatPools          : []
Sku                      : {
                             "Name": "Standard",
                             "Tier": "Regional"
                           }
ExtendedLocation         : null

```

# Creating Virtual Machines
Commands referring from [Virtual Machine](./003virtualmachine.ps1)

Create a Virtual Machine for the Regions:
- Creating a VM Availability Set
- Creating Network Interface for each Virtual Machine
	- Creating Interface based on Subnets and Regions
- Creating an Array Set of basic VM details
- Creating VMs
	- Associating VMs with Availability Set
	- Creating a VM Operating System
	- Setting a VM Image
	- Adding VM Interface
	- Disabling Boot Diagnostic
- Setting CPU Alerts
	- Creating an Action Reciever
	- Creating an Action Group
	- Setting Criteria for the Alert
	- Creating a Action Rule

Below is the output of the final action rule created

```powershell
Description          : alert on CPU > 80%
Severity             : 4
Enabled              : True
Scopes               : {/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Compute/virtualMachines/webserver01,
                       /subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Compute/virtualMachines/webserver11}
EvaluationFrequency  : 00:05:00
WindowSize           : 00:05:00
TargetResourceType   : Microsoft.Compute/virtualMachines
TargetResourceRegion : australiaeast
Criteria             : Microsoft.Azure.Management.Monitor.Models.MetricAlertMultipleResourceMultipleMetricCriteria
AutoMitigate         : True
Actions              : {/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/microsoft.insights/actionGroups/Act_CPUHigh}
LastUpdatedTime      :
Id                   : /subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/Nilavembu_SEA/providers/Microsoft.Insights/metricAlerts/vmcpu_gt_80
Name                 : vmcpu_gt_80
Type                 : Microsoft.Insights/metricAlerts
Location             : global
Tags                 :

```

# Creating a Backup of VMs
Commands referring from [Backup](./004backup.ps1)

VMs are created and Backup for those VMs are added by the below process:
- Registering the Backup Service Provider
- Creating a Recovery Service Vault
- Creating a Backup Protection Policy
	- Create a Backup Policy
	- And a Retention Policy
	- Disable other Retention Settings
- Enabling Backup Services for the Virtual Machines with the defined sets

# Creating Storage Account
Commands referring from [Storage Account](./005storage.ps1)

Storage Account is created in both the regions as follows:
- SEA Region with ZRS Storage Account
- EUS Region with GRS Storage Account
- Both Storage have File Share, Container
- SAS Key is generated for the container and provided to the user


# Creating Identities
Commands referring from [Identity & RBAC](./006identity.ps1)

Identity can be created with Azure AD Commands, and assigning roles to the AD User respectively:
- Creating a Virtual Machine Contributor
- Creating a Backup Contributor for EUS Servers only

# Final

For Final Setup we remove the Resource Group created.

```powershell
Remove-AzResourceGroup $RG[0] -Force
Remove-AzResourceGroup $RG[1] -Force
```
