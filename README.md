---
#YAML
name: Mahmood Athil
id: 666078
org: Tech Mahindra
batch: COE1A
project: Case Study
---

# Introduction

Creating a Project for the case study as discussed/presented on the presentation [Case Study pptx](./AzureCase_TM_coe_v2.pptx). Please Follow the [Navigation](#^ea1f69) to explore the files.

# Objective

- [x] Knowledge on Basic Cloud Services from Azure
- [x] Navigating Azure Portal
- [x] Using PowerShell + Azure cmdlets
- [x] Using Azure CLI
- [x] Using Terraform for Provisioning
- [x] Using Ansible
- [Mastery Acquired] Patience

# Resource Created

Resources are created for each Resource Group representing different geography. The final Infrastructure Diagram is represented in [Network Diagram](./Case_Study%20Implementation.pdf)

Below are the name of the resources for each resource group :

| Resources            |    Nilavembu_SEA     | Nilavembu_EUS  |
|:-------------------- |:--------------------:|:--------------:|
| **Virtual Network**  |       sea-vnet       |    eus-vnet    |
| **Subnet**           |    sea-web-subnet    | eus-web-subnet |
|                      |   sea-jump-subnet    |                |
| **ASGs**             |     sea-web-asg      |  eus-web-asg   |
|                      |     sea-jump-asg     |                |
| **NSGs**             |       sea-nsg        |    eus-nsg     |
| NSG Rule             |     Allow_HTTP_S     |  Allow_HTTP_S  |
|                      |      Allow_RDP       |   Allow_RDP    |
|                      |      Allow_FTP       |                |
| **Load Balancer**    |        sea-lb        |                |
| Frontend IP          | LoadBalancerFrontEnd |                |
| Backend Pool         |       sea-lbbp       |                |
| Health Probe         |   webserver-health   |                |
|                      |  webserver-health-s  |                |
| Inbound NAT Rule     |   nat-RDP:420:3389   |                |
|                      |  nat-RDP2:421:3389   |                |
| **Virtual Machines** |      webserver1      |    server11    |
|                      |     webserver11      |                |
|                      |      jumpserver      |                |
| **Backup**           |    sea-web-bckup     |                |
| **Storage Account**  |     nilsestorage     |  nileustorage  |


SEA Region: ![SEA Region](SEA%20Region.png)

EUS Region: ![](EUS%20Region.png)

**Global**:
- User Creation:
	- User 1: vmadmin (scope level : subscription)
	- User 2: backupadmin (scope level : Nilavembu_EUS)
	- ![](Tenant%20Users.png)
- Traffic Manager Profile
	- ![](Traffic%20Manager.png)


# Navigation

^ea1f69

- **Case Study on [Azure Portal](./Portal/Azure%20Portal.md)**
- **Case Study using [Azure PowerShell](./PowerShell/Azure%20PowerShell.md)**
	- PowerShell Scripts:
		- [Pre-Requisite for Working](./PowerShell/000prerequisite.ps1)
		- [Creating Network Components](./PowerShell/001network.ps1)
		- [Creating a Load Balancer](./PowerShell/002loadbalancer.ps1)
		- [Creating Virtual Machines](./PowerShell/003virtualmachine.ps1)
		- [Creating a Backup Vault of VM](./PowerShell/004backup.ps1)
		- [Creating Storage Account](./PowerShell/005storage.ps1)
		- [Creating Identities with AzureAD](./PowerShell/006identity.ps1)
- **Case Study using [Terraform](./Terraform/Terraform.md)**
	- Terraform Scripts:
		- [Adding in Providers for Azure](./Terraform/provider.tf)
		- [Creating in Variables](./Terraform/variables.tf)
		- [Adding in Variables](./Terraform/terraform.tfvars)
		- [Creting Resources for SEA Region](./Terraform/main_sea.tf)
		- [Creting Resources for EUS Region](./Terraform/main_eus.tf)
		- [Creating AD Identity](./Terraform/ad_identity.tf)
		- [Creting Output](./Terraform/output.tf)
- **Case Study using [Ansible](../Ansible/Ansible.md)**
	- Ansible Scripts - All the YAML scripts can be listed as follows:
		- [Resource Group Creation](Ansible/playbook_01rg.yaml)
		- [Virtual Network Creation](Ansible/playbook_02anetwork.yaml)
		- [Network Peering Creation](Ansible/playbook_02bpeer.yaml)
		- [Application Security Group Creation](Ansible/playbook_03asg.yaml)
		- [Network Security Group Creation](Ansible/playbook_04nsg.yaml)
		- [Public IP Creation](Ansible/playbook_05pubip.yaml)
		- [Load Balancer Creation](Ansible/playbook_06lb.yaml)
		- [Network Interface Creation](Ansible/playbook_07nic.yaml)
		- [Availability Set Creation](Ansible/playbook_08avs.yaml)
		- [Virtual Machine Creation](Ansible/playbook_09vm.yaml)
		- [Storage Creation](Ansible/playbook_10strg.yaml)
		- [Recovery Service Vault & Backup Creation](Ansible/playbook_11bkp.yaml)
		- [Identity - Not Working](Ansible/playbook_12identity.yaml)
		- [Resource Deletion](Ansible/playbook_13del.yaml)
- **Case Study Using [Azure CLI](CLI/Azure%20CLI.md)**
	- CLI Scripts:
		- [Pre-Requisites & Resource Group](CLI/000prerequisite.sh)
		- [Network Resources](CLI/001network.sh)
		- [Load Balancer](CLI/002loadbalancer.sh)
		- [Virtual Machine](CLI/003virtualmachine.sh)
		- [Backup Components](CLI/004bkp.sh)
		- [Storage Accounts & Components](CLI/005strg.sh)
		- [Identity & Role Assignments](CLI/006identity.sh)
- **ARM Templates for the regions**
	- [SEA RG Template](ARM%20Template/sea_rg/template.json)
	- [EUS RG Template](ARM%20Template/eus_rg/template.json)
- Other Previous Tasks
	- [All Initial Assessment](Previous%20Task/Assessment/)
	- Misc Tasks
		- [Function to Add VMs with Data Disks](Previous%20Task/Regular%20Tasks/New-AzVMwithDisk.ps1)
		- [Random Network Creation](Previous%20Task/Regular%20Tasks/NetworkCreation.ps1) 



