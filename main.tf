# Versioning
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.68.0"
    }
  }
}


#Providers with sp
provider "azurerm" {
  features {}

  client_id       = var.clientid
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Terraform backend state
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstaterg"
    storage_account_name = "tfstaterg12122023"
    container_name       = "today"
    key                  = "msv.terraform.tfstate"
  }
}

#esource creation
resource "azurerm_resource_group" "example" {
  name     = var.rgn
  location = var.location
}

# Storage account
resource "azurerm_storage_account" "example" {
  #name                     = lower(var.storageaccountname)
  name                     = "${lower(var.storageaccountname)}${count.index+1}"
   count=var.countvalue
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

#vnet
resource "azurerm_virtual_network" "example" {
  depends_on          = [azurerm_network_security_group.example]
  name                = var.vnet
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = var.vnetaddressspace
}

#subnet
resource "azurerm_subnet" "example" {
  depends_on           = [azurerm_network_security_group.example]
  name                 = var.ksubnet
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.ksubnetaddress

}

#public ip
resource "azurerm_public_ip" "example" {
  name                = var.kpublicip
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"

}

#Nic
resource "azurerm_network_interface" "example" {
  depends_on          = [azurerm_public_ip.example, azurerm_subnet.example]
  name                = var.knic
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

#NSG
resource "azurerm_network_security_group" "example" {
  name                = var.knsg
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}


#Associate NSG and Subnet


resource "azurerm_subnet_network_security_group_association" "example" {
  depends_on                = [azurerm_network_security_group.example, azurerm_subnet.example]
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}


#VM


resource "azurerm_windows_virtual_machine" "example" {
  depends_on          = [azurerm_network_interface.example]
  name                = var.kvm
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.ksize
  admin_username      = var.adminuser
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.example.id,
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
