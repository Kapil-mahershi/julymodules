variable "clientid" {
  type    = string
  default = "a0359390-2b92-4d03-b791-1cfc7ffd653d"
}
variable "client_secret" {
  type    = string
  default = "xH38Q~4C3rWr5sseMQ94qaO4PB9YmoFiISmdzaD5"
}
variable "tenant_id" {
  type    = string
  default = "b240b83e-e065-43b9-8761-ccfe9f2b41c2"
}
variable "subscription_id" {
  type    = string
  default = "aa44ce28-87a5-4bda-81b7-70ca70299542"
}

variable "rgn" {
  type    = string
  default = "terraform0809-rg"
}
variable "location" {
  type    = string
  default = "eastus"
}

variable "storageaccountname" {
  type    = string
  default = "kapilstorage08092023"
}

variable "vnet" {
  type    = string
  default = "kapilvnet09092023"
}
variable "vnetaddressspace" {
  type    = list(any)
  default = ["10.0.0.0/24"]
}
variable "ksubnet" {
  type    = string
  default = "kapilsubnet0909"
}
variable "ksubnetaddress" {
  type    = list(any)
  default = ["10.0.0.0/24"]
}

variable "kpublicip" {
  type    = string
  default = "kpublicip0909"
}

variable "knsg" {
  type    = string
  default = "knsg09092023"
}

variable "knic" {
  type    = string
  default = "knic09092023"
}

variable "kvm" {
  type    = string
  default = "kvm09092023"
}

variable "ksize" {
  type    = string
  default = "Standard_Ds1_V2"
}

variable "adminuser" {
  type    = string
  default = "azureuser"
}
variable "admin_password" {
  type    = string
  default = "Kapil@1234"
}
variable "countvalue" {
  type    = number
  default = 3
}