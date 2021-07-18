data "azurerm_subscription" "subscription" {
}

# VM Admin User
resource "azuread_user" "vm" {
  user_principal_name = "vm_admin1@mehervalluri5outlook.onmicrosoft.com"
  display_name        = "vm_admin1"
  mail_nickname       = "vm1"
  password            = "CfsPassword@123"
}

data "azurerm_role_definition" "vmadmin" { 
  name  = "Virtual Machine Contributor"
  scope = data.azurerm_subscription.subscription.id
}

resource "azurerm_role_assignment" "vmrole_sub" {
  scope                = data.azurerm_subscription.subscription.id
  role_definition_name = data.azurerm_role_definition.vmadmin.name
  principal_id         = azuread_user.vm.object_id
}

# Backup Admin
resource "azuread_user" "bckp" {
  user_principal_name = "backup1_admin@mehervalluri5outlook.onmicrosoft.com"
  display_name        = "backup1_admin"
  mail_nickname       = "bckp1"
  password            = "CfsPassword@123"
}

data "azurerm_role_definition" "bckpadmin" { 
  name  = "Backup Contributor"
  scope = azurerm_windows_virtual_machine.server11.id
}

resource "azurerm_role_assignment" "bckprole_server11" {
  scope                = data.azurerm_role_definition.bckpadmin.scope
  role_definition_name = data.azurerm_role_definition.bckpadmin.name
  principal_id         = azuread_user.bckp.object_id
}
