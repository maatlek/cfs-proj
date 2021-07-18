output "SEA_Resource_Group" {
  value = azurerm_resource_group.searg.location
}

output "EUS_Resource_Group" {
  value = azurerm_resource_group.eusrg.location
}

output "SEA_virtual_Network_Name" {
  value = azurerm_virtual_network.seavnet.name
}

output "SEA_Virtual_Network_Subnet" {
  value = azurerm_virtual_network.seavnet.subnet
}

output "EUS_virtual_Network_Name" {
  value = azurerm_virtual_network.eusvnet.name
}

output "EUS_Virtual_Network_Subnet" {
  value = azurerm_virtual_network.eusvnet.subnet
}

output "SEA_Network_Security_Group_rules" {
  value = azurerm_network_security_group.seansg.security_rule
}

output "EUS_Network_Security_Group_rules" {
  value = azurerm_network_security_group.eusnsg.security_rule
}

output "SEA_VMs" {
  value = {
      VM1 = azurerm_windows_virtual_machine.webserver1.name
      VM2 = azurerm_windows_virtual_machine.webserver2.name
      VM3 = azurerm_windows_virtual_machine.jumpserver.name
  }
}

output "SEA_Load_Balancer" {
  value = azurerm_lb.sea_lb.frontend_ip_configuration
}

output "EUS_VMs" {
  value = {
      VM1 = azurerm_windows_virtual_machine.server11.name
  }
}

output "SEA_Backup_Vault" {
  value = azurerm_backup_protected_vm.webbckp1.recovery_vault_name
}

output "SEA_Storage" {
  value = azurerm_storage_account.seastrg.name
}

output "EUS_Storage" {
  value = azurerm_storage_account.eusstrg.name
}

output "sea_sas_url_query_string" {
  value = data.azurerm_storage_account_sas.seasaskey.sas
  sensitive = true
}

output "eus_sas_url_query_string" {
  value = data.azurerm_storage_account_sas.eussaskey.sas
  sensitive = true
}

output "User_for_VM_Contribution" {
  value = azuread_user.vm.display_name
}

output "User_for_Backup_Contribution" {
  value = azuread_user.bckp.display_name
}


