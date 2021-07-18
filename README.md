---
#YAML
name: Mahmood Athil
id: 666078
Company: Tech Mahindra
Batch: COE1A
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
- ARM Templates for the regions
	- [template](ARM%20Template/sea_rg/template.json)
	- [template](ARM%20Template/eus_rg/template.json)


# Objective
- [x] Knowledge on Basic Cloud Services from Azure
- [x] Navigating Azure Portal
- [x] Using PowerShell + Azure cmdlets
- [Basic Use Cases] Using Azure CLI (On-Progess)
- [x] Using Terraform for Provisioning
- [Basic Use Cases] Using Ansible (On-Progress)
- [Mastery Acquired] Patience