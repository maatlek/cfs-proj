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
- Creating a Resource Group
- Creating Network Components
	- Application Security Group
	- Network Security Group
		- Network Rules
	- Virtual Network
		- Subnet
