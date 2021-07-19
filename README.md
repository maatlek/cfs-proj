---
#YAML
name: Mahmood Athil
id: 666078
org: Tech Mahindra
batch: COE1A
project: Case Study
---

# Introduction
Creating a Project for the case study as discussed/presented on the presentation [Case Study pptx](./AzureCase_TM_coe_v2.pptx)

# Navigation
- Infrastructure Plan with a [Network Diagram](./Case_Study%20Implementation.pdf)
- Case Study on [Azure Portal](./Portal/Azure%20Portal.md) 
- Case Study using [Azure PowerShell](./PowerShell/Azure%20PowerShell.md)
	- PowerShell Scripts:
		- [Pre-Requisite for Working](./PowerShell/000prerequisite.ps1)
		- [Creating Network Components](./PowerShell/001network.ps1)
		- [Creating a Load Balancer](./PowerShell/002loadbalancer.ps1)
		- [Creating Virtual Machines](./PowerShell/003virtualmachine.ps1)
		- [Creating a Backup Vault of VM](./PowerShell/004backup.ps1)
		- [Creating Storage Account](./PowerShell/005storage.ps1)
		- [Creating Identities with AzureAD](./PowerShell/006identity.ps1)
- Case Study using [Terraform](./Terraform/Terraform.md)
	- Terraform Scripts:
		- [Adding in Providers for Azure](./Terraform/provider.tf)
		- [Creating in Variables](./Terraform/variables.tf)
		- [Adding in Variables](./Terraform/terraform.tfvars)
		- [Creting Resources for SEA Region](./Terraform/main_sea.tf)
		- [Creting Resources for EUS Region](./Terraform/main_eus.tf)
		- [Creating AD Identity](./Terraform/ad_identity.tf)
		- [Creting Output](./Terraform/output.tf)
- Case Study using [Ansible](../Ansible/Ansible.md)
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
		- [Resource Deletion](Ansible/playbook_12del.yaml)
- ARM Templates for the regions
	- [template](ARM%20Template/sea_rg/template.json)
	- [template](ARM%20Template/eus_rg/template.json)


# Objective
- [x] Knowledge on Basic Cloud Services from Azure
- [x] Navigating Azure Portal
- [x] Using PowerShell + Azure cmdlets
- [Basic Use Cases] Using Azure CLI (On-Progess)
- [x] Using Terraform for Provisioning
- [x] Using Ansible
- [Mastery Acquired] Patience