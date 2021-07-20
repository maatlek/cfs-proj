Creating the Case Study with PowerShell

# Intial Configuration
Commands refer to [Pre-Requisite](./000prerequisite.ps1)
```bash

#!bin/bash

# Update Package repo
sudo apt-get update

# Installation on Debian
sudo apt-get install azure-cli

# Installation on Cent OS, RHEL
sudo yum install azure-cli

# Connect
az login

```

Once Successful Login, we prepare by creating the resources.

# Creating Resources
Resources are created in the following order:
- Creating a Resource Group (as a part of pre-requisite)
- Creating [Network Components](001network.sh)
	- Application Security Group
	- Network Security Group
		- Network Rules
	- Virtual Network
		- Subnet
		- Peering
- Creating a [Load Balancer](002loadbalancer.sh)
	- Creating a Front End IP
	- Creating a Back End Pool
	- Creating a Health Probe
	- Creating a Rule connected with the Probe
		- Providing a session persistence
	- Creating a Inbound NAT Rule
- Creating a [Virtual Machine](003virtualmachine.sh)
	- Creating a NIC
	- Adding Public IPs
	- Associating backend pools with NICs
	- Creating an Availability Set
	- Creating all the Virtual Machines
- Creating a [Backup for SEA WebServers](004bkp.sh)
	- Adding a Recovery Services Vault
	- Adding a Backup with Default Policy
- Creating a [Storage Account](005strg.sh)
	- Creating Containers along
	- Creating Storage Share
	- Creating SAS Connection String to local file
- Creating an [AD User](006identity.sh)
	- Assingning users to Roles in required Scope

# Final
Cleaning up all the resources with
```bash

az group delete \ 
	--resource-group mknilavembu_rgsea

az group delete \ 
	--resource-group mknilavembu_rgeus

```