# Resource Group
resource "azurerm_resource_group" "searg" {
  name     = var.rg[0]
  location = var.location[0]
}


# Virtual Network
resource "azurerm_virtual_network" "seavnet" {
  name                = var.vnet[0]
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.searg.location
  resource_group_name = azurerm_resource_group.searg.name
}

# Subnet
resource "azurerm_subnet" "sea_web_subnet" {
  name                 = var.subnet[0]
  resource_group_name = azurerm_resource_group.searg.name
  virtual_network_name = azurerm_virtual_network.seavnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "sea_jump_subnet" {
  name                 = var.subnet[1]
  resource_group_name = azurerm_resource_group.searg.name
  virtual_network_name = azurerm_virtual_network.seavnet.name
  address_prefixes     = ["10.2.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Virtual Network Peering
resource "azurerm_virtual_network_peering" "peersea-eus" {
  name                      = "peer_sea-eus"
  resource_group_name       = azurerm_resource_group.searg.name
  virtual_network_name      = azurerm_virtual_network.seavnet.name
  remote_virtual_network_id = azurerm_virtual_network.eusvnet.id
}


# Application Security Group
resource "azurerm_application_security_group" "sea_web_asg" {
  name                = var.asg[0]
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
}

resource "azurerm_application_security_group" "sea_jump_asg" {
  name                = var.asg[1]
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
}

# Network Security Group
resource "azurerm_network_security_group" "seansg" {
  name                = var.nsg[0]
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
}

## Rules
resource "azurerm_network_security_rule" "seaallow_rdp" {
  name                        = "allow_RDP"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.searg.name
  network_security_group_name = azurerm_network_security_group.seansg.name
}

resource "azurerm_network_security_rule" "seaallow_httphttps" {
  name                        = "allow_80443"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = ["80","443"]
  source_address_prefix       = "*"
  destination_application_security_group_ids  = [azurerm_application_security_group.sea_web_asg.id]
  resource_group_name         = azurerm_resource_group.searg.name
  network_security_group_name = azurerm_network_security_group.seansg.name
}

resource "azurerm_network_security_rule" "seaallow_ftp" {
  name                        = "allow_80443"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "21"
  source_application_security_group_ids     = [azurerm_application_security_group.sea_jump_asg.id]
  destination_application_security_group_ids  = [azurerm_application_security_group.sea_web_asg.id]
  resource_group_name         = azurerm_resource_group.searg.name
  network_security_group_name = azurerm_network_security_group.seansg.name
}


# Creating Public IP Address
resource "azurerm_public_ip" "jump_pub_ip" {
  name                = "jump_pub_ip"
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "sea_lb_ip" {
  name                = "sea_lb_ip"
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
  allocation_method   = "Static"
}

# Load Balancer

## Frontend IP
resource "azurerm_lb" "sea_lb" {
  name                = "sea_lb"
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location

  frontend_ip_configuration {
    name                 = "primary"
    public_ip_address_id = azurerm_public_ip.sea_lb_ip.id
  }
}

## Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "sea_lb_bcknd" {
  loadbalancer_id     = azurerm_lb.sea_lb.id
  name                = "web_bcknd"
}

## Load Balancer Probe
resource "azurerm_lb_probe" "sea_lb_probe1" {
  resource_group_name = azurerm_resource_group.searg.name
  loadbalancer_id     = azurerm_lb.sea_lb.id
  name                = "https-running-probe"
  port                = 443
}

resource "azurerm_lb_probe" "sea_lb_probe2" {
  resource_group_name = azurerm_resource_group.searg.name
  loadbalancer_id     = azurerm_lb.sea_lb.id
  name                = "http-running-probe"
  port                = 80
}

## Load Balancer Rule
resource "azurerm_lb_rule" "allow80" {
  resource_group_name            = azurerm_resource_group.searg.name
  loadbalancer_id                = azurerm_lb.sea_lb.id
  name                           = "LBRule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "primary"
}

resource "azurerm_lb_rule" "allow443" {
  resource_group_name            = azurerm_resource_group.searg.name
  loadbalancer_id                = azurerm_lb.sea_lb.id
  name                           = "LBRule2"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "primary"
}


# Network Interface

## Web1
resource "azurerm_network_interface" "web1nic" {
  name                = "${var.VM[0]}-nic"
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location

  ip_configuration {
    name                          = "${var.VM[0]}-pip"
    subnet_id                     = azurerm_subnet.sea_web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

## Web2
resource "azurerm_network_interface" "web2nic" {
  name                = "${var.VM[1]}-nic"
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location

  ip_configuration {
    name                          = "${var.VM[1]}-pip"
    subnet_id                     = azurerm_subnet.sea_web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

## Jump
resource "azurerm_network_interface" "jumpnic" {
  name                = "${var.VM[2]}-nic"
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location

  ip_configuration {
    name                          = "${var.VM[2]}-pip"
    subnet_id                     = azurerm_subnet.sea_jump_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.jump_pub_ip.id
  }
}


## Associating with ASG
resource "azurerm_network_interface_application_security_group_association" "seaw1nic-asg" {
  network_interface_id          = azurerm_network_interface.web1nic.id
  application_security_group_id = azurerm_application_security_group.sea_web_asg.id
}

resource "azurerm_network_interface_application_security_group_association" "seaw2nic-asg" {
  network_interface_id          = azurerm_network_interface.web2nic.id
  application_security_group_id = azurerm_application_security_group.sea_web_asg.id
}

resource "azurerm_network_interface_application_security_group_association" "seajnic-asg" {
  network_interface_id          = azurerm_network_interface.jumpnic.id
  application_security_group_id = azurerm_application_security_group.sea_jump_asg.id
}


## Associating with NSG
resource "azurerm_subnet_network_security_group_association" "seawsublink-nsg" {
  subnet_id                 = azurerm_subnet.sea_web_subnet.id
  network_security_group_id = azurerm_network_security_group.seansg.id
}

resource "azurerm_subnet_network_security_group_association" "seajsublink-nsg" {
  subnet_id                 = azurerm_subnet.sea_jump_subnet.id
  network_security_group_id = azurerm_network_security_group.seansg.id
}

## Associating with Load Balancer Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "web1lb" {
  network_interface_id    = azurerm_network_interface.web1nic.id
  ip_configuration_name   = "${var.VM[0]}-pip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.sea_lb_bcknd.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web2lb" {
  network_interface_id    = azurerm_network_interface.web2nic.id
  ip_configuration_name   = "${var.VM[1]}-pip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.sea_lb_bcknd.id
}

# Creating an Availability Set
resource "azurerm_availability_set" "sea_avs" {
  name                = "sea-avs"
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
  platform_update_domain_count = 1
  platform_fault_domain_count = 2
}

# Creating a Virtual Machine

resource "azurerm_windows_virtual_machine" "webserver1" {
  name                = var.VM[0]
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
  size                = "Standard_DS1_v2"
  admin_username      = "mkadmin"
  admin_password      = "Password@123"
  network_interface_ids = [
    azurerm_network_interface.web1nic.id
  ]
  availability_set_id = azurerm_availability_set.sea_avs.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


resource "azurerm_windows_virtual_machine" "webserver2" {
  name                = var.VM[1]
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
  size                = "Standard_DS1_v2"
  admin_username      = "mkadmin"
  admin_password      = "Password@123"
  network_interface_ids = [
    azurerm_network_interface.web2nic.id
  ]
  availability_set_id = azurerm_availability_set.sea_avs.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


resource "azurerm_windows_virtual_machine" "jumpserver" {
  name                = var.VM[2]
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
  size                = "Standard_DS1_v2"
  admin_username      = "mkadmin"
  admin_password      = "Password@123"
  network_interface_ids = [
    azurerm_network_interface.jumpnic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

# Virtual Machine Backup

resource "azurerm_recovery_services_vault" "sea_vault" {
  name                = "seabckp-vault"
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
  sku                 = "Standard"
}

resource "azurerm_backup_policy_vm" "daily_bckp" {
  name                = "dlybackp-policy"
  resource_group_name = azurerm_resource_group.searg.name
  recovery_vault_name = azurerm_recovery_services_vault.sea_vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 10
  }
}

resource "azurerm_backup_protected_vm" "webbckp1" {
  resource_group_name = azurerm_resource_group.searg.name
  recovery_vault_name = azurerm_recovery_services_vault.sea_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.webserver1.id
  backup_policy_id    = azurerm_backup_policy_vm.daily_bckp.id
}

resource "azurerm_backup_protected_vm" "webbckp2" {
  resource_group_name = azurerm_resource_group.searg.name
  recovery_vault_name = azurerm_recovery_services_vault.sea_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.webserver2.id
  backup_policy_id    = azurerm_backup_policy_vm.daily_bckp.id
}

# Storage Account
resource "azurerm_storage_account" "seastrg" {
  name                = var.strgaccount[0]
  resource_group_name = azurerm_resource_group.searg.name
  location            = azurerm_resource_group.searg.location
  account_tier        = "Standard"
  access_tier         = "Cool"
  account_replication_type = "ZRS"
}

resource "azurerm_storage_container" "sea_continer" {
  name                  = "sales"
  storage_account_name  = azurerm_storage_account.seastrg.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "salesmshare_sea" {
  name                 = "salesshare"
  storage_account_name = azurerm_storage_account.seastrg.name
  quota                = 10
}