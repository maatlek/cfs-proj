# Terraform
Creating similar case study with Terraform.

Similar Steps are followed as same as in powershell.

Below Output is generated:
```bash
Outputs:

EUS_Network_Security_Group_rules = toset([
  {
    "access" = "Allow"
    "description" = ""
    "destination_address_prefix" = ""
    "destination_address_prefixes" = toset([])
    "destination_application_security_group_ids" = toset([
      "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_eus/providers/Microsoft.Network/applicationSecurityGroups/eus-web-asg",
    ])
    "destination_port_range" = ""
    "destination_port_ranges" = toset([
      "443",
      "80",
    ])
    "direction" = "Inbound"
    "name" = "allow_80443"
    "priority" = 100
    "protocol" = "Tcp"
    "source_address_prefix" = "*"
    "source_address_prefixes" = toset([])
    "source_application_security_group_ids" = toset([])
    "source_port_range" = "*"
    "source_port_ranges" = toset([])
  },
  {
    "access" = "Allow"
    "description" = ""
    "destination_address_prefix" = "*"
    "destination_address_prefixes" = toset([])
    "destination_application_security_group_ids" = toset([])
    "destination_port_range" = "*"
    "destination_port_ranges" = toset([])
    "direction" = "Outbound"
    "name" = "allow_RDP"
    "priority" = 130
    "protocol" = "Tcp"
    "source_address_prefix" = "*"
    "source_address_prefixes" = toset([])
    "source_application_security_group_ids" = toset([])
    "source_port_range" = "*"
    "source_port_ranges" = toset([])
  },
])
EUS_Resource_Group = "canadacentral"
EUS_Storage = "nilveusstorage"
EUS_VMs = {
  "VM1" = "server11"
}
EUS_Virtual_Network_Subnet = toset([
  {
    "address_prefix" = "192.168.0.0/24"
    "id" = "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_eus/providers/Microsoft.Network/virtualNetworks/eus_vnet/subnets/eus_web_sub"
    "name" = "eus_web_sub"
    "security_group" = "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_eus/providers/Microsoft.Network/networkSecurityGroups/eus-nsg"
  },
])
EUS_virtual_Network_Name = "eus_vnet"
SEA_Backup_Vault = "tfex-recovery-vault"
SEA_Load_Balancer = tolist([
  {
    "availability_zone" = "No-Zone"
    "id" = "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_sea/providers/Microsoft.Network/loadBalancers/sea_lb/frontendIPConfigurations/primary"
    "inbound_nat_rules" = toset([])
    "load_balancer_rules" = toset([
      "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_sea/providers/Microsoft.Network/loadBalancers/sea_lb/loadBalancingRules/LBRule1",
      "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_sea/providers/Microsoft.Network/loadBalancers/sea_lb/loadBalancingRules/LBRule2",
    ])
    "name" = "primary"
    "outbound_rules" = toset([])
    "private_ip_address" = ""
    "private_ip_address_allocation" = "Dynamic"
    "private_ip_address_version" = ""
    "public_ip_address_id" = "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_sea/providers/Microsoft.Network/publicIPAddresses/sea_lb_ip"
    "public_ip_prefix_id" = ""
    "subnet_id" = ""
    "zones" = tolist([])
  },
])
SEA_Network_Security_Group_rules = toset([])
SEA_Resource_Group = "australiaeast"
SEA_Storage = "nilvseastorage"
SEA_VMs = {
  "VM1" = "webserver01"
  "VM2" = "webserver11"
  "VM3" = "jumpserver"
}
SEA_Virtual_Network_Subnet = toset([
  {
    "address_prefix" = "10.1.0.0/24"
    "id" = "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_sea/providers/Microsoft.Network/virtualNetworks/sea_vnet/subnets/sea_web_sub"
    "name" = "sea_web_sub"
    "security_group" = ""
  },
  {
    "address_prefix" = "10.2.0.0/24"
    "id" = "/subscriptions/0ddb8f2f-e4c9-4460-94f9-84af943ebabf/resourceGroups/mknilavembu_sea/providers/Microsoft.Network/virtualNetworks/sea_vnet/subnets/sea_jump_sub"
    "name" = "sea_jump_sub"
    "security_group" = ""
  },
])
SEA_virtual_Network_Name = "sea_vnet"
User_for_Backup_Contribution = "backup1_admin"
User_for_VM_Contribution = "vm_admin1"
eus_sas_url_query_string = <sensitive>
sea_sas_url_query_string = <sensitive>
```