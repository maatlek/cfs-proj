# Resource Group
resource "azurerm_resource_group" "eusrg" {
  name     = var.rg[1]
  location = var.location[1]
}

# Virtual Network
resource "azurerm_virtual_network" "eusvnet" {
  name                = var.vnet[1]
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.eusrg.location
  resource_group_name = azurerm_resource_group.eusrg.name
}

# Subnet
resource "azurerm_subnet" "eus_web_subnet" {
  name                 = var.subnet[2]
  resource_group_name = azurerm_resource_group.eusrg.name
  virtual_network_name = azurerm_virtual_network.eusvnet.name
  address_prefixes     = ["192.168.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Virtual Network Peering
resource "azurerm_virtual_network_peering" "peereus_sea" {
  name                      = "peer_eus-sea"
  resource_group_name       = azurerm_resource_group.eusrg.name
  virtual_network_name      = azurerm_virtual_network.eusvnet.name
  remote_virtual_network_id = azurerm_virtual_network.seavnet.id
}

# Application Security Group
resource "azurerm_application_security_group" "eus_web_asg" {
  name                = var.asg[2]
  resource_group_name = azurerm_resource_group.eusrg.name
  location            = azurerm_resource_group.eusrg.location
}

# Network Security Group
resource "azurerm_network_security_group" "eusnsg" {
  name                = var.nsg[1]
  resource_group_name = azurerm_resource_group.eusrg.name
  location            = azurerm_resource_group.eusrg.location
}

## Rules
resource "azurerm_network_security_rule" "eusallow_rdp" {
  name                        = "allow_RDP"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.eusrg.name
  network_security_group_name = azurerm_network_security_group.eusnsg.name
}

resource "azurerm_network_security_rule" "eusallow_httphttps" {
  name                        = "allow_80443"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = ["80","443"]
  source_address_prefix       = "*"
  destination_application_security_group_ids  = [azurerm_application_security_group.eus_web_asg.id]
  resource_group_name         = azurerm_resource_group.eusrg.name
  network_security_group_name = azurerm_network_security_group.eusnsg.name
}

# Creating Public IP Address
resource "azurerm_public_ip" "s11_pub_ip" {
  name                = "s11_pub_ip"
  resource_group_name = azurerm_resource_group.eusrg.name
  location            = azurerm_resource_group.eusrg.location
  allocation_method   = "Static"
}

# Network Interface
resource "azurerm_network_interface" "server11nic" {
  name                = "${var.VM[3]}-nic"
  resource_group_name = azurerm_resource_group.eusrg.name
  location            = azurerm_resource_group.eusrg.location

  ip_configuration {
    name                          = "${var.VM[3]}-pip"
    subnet_id                     = azurerm_subnet.eus_web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.s11_pub_ip.id
  }
}

## Associating with ASG
resource "azurerm_network_interface_application_security_group_association" "euswnic-asg" {
  network_interface_id          = azurerm_network_interface.server11nic.id
  application_security_group_id = azurerm_application_security_group.eus_web_asg.id
}

## Associating with NSG
resource "azurerm_subnet_network_security_group_association" "euswsublink-nsg" {
  subnet_id                 = azurerm_subnet.eus_web_subnet.id
  network_security_group_id = azurerm_network_security_group.eusnsg.id
}

# Creating a Virtual Machine
resource "azurerm_windows_virtual_machine" "server11" {
  name                = var.VM[3]
  resource_group_name = azurerm_resource_group.eusrg.name
  location            = azurerm_resource_group.eusrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "mkadmin"
  admin_password      = "Password@123"
  network_interface_ids = [
    azurerm_network_interface.server11nic.id
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

# Storage Account
resource "azurerm_storage_account" "eusstrg" {
  name                = var.strgaccount[1]
  resource_group_name = azurerm_resource_group.eusrg.name
  location            = azurerm_resource_group.eusrg.location
  account_tier        = "Standard"
  access_tier         = "Cool"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "eus_container" {
  name                  = "sales"
  storage_account_name  = azurerm_storage_account.eusstrg.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "salesmshare_eus" {
  name                 = "salesshare"
  storage_account_name = azurerm_storage_account.eusstrg.name
  quota                = 10
}