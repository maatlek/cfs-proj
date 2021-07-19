# Ansible

We create Ansible Playbooks to create a playbook.
Steps:
- Create a config file to update the configurations needed for Ansible working
- Create Resources in the following order:
	- Resource Group
	- Virtual Network
	- Application Security Group
	- Network Security Group
	- Network Peering
	- Public IP
	- Load Balancer
	- Network Interface
	- Availability Set
	- Virtual Machine
	- Storage
	- Recovery Services Vault

# Debug Messages
Follwoing Messages can be provided for successful resource creation:
```bash
$ ansible-playbook playbook_01rg.yaml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Creating RG in SEA Region] *******************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************
ok: [localhost]

TASK [Create resource group] ***********************************************************************************************************************************************
ok: [localhost]

TASK [Provide RG Details] **************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "The Resource Group mknilavembu_sea in the location australiaeast."
}

PLAY [Creating RG in EUS Region] *******************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************
ok: [localhost]

TASK [Create resource group] ***********************************************************************************************************************************************
changed: [localhost]

TASK [Provide RG Details] **************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "The Resource Group mknilavembu_eus in the location canadacentral."
}

PLAY RECAP *****************************************************************************************************************************************************************
localhost                  : ok=6    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

# Final Deletion
- Final Deletion of all the Resource Group at Resource Group level, as below:

```yaml
- name: Delete a resource group including resources it contains
  hosts: hostname
  connection: local
  tasks:
  - name: Delete SEA RG
    azure_rm_resourcegroup:
      name: mknilavembu_sea
      force_delete_nonempty: yes
      state: absent
  - name: Delete EUS RG
    azure_rm_resourcegroup:
      name: mknilavembu_eus
      force_delete_nonempty: yes
      state: absent
```

