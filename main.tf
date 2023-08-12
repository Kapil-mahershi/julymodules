

#esource creation
resource "azurerm_resource_group" "example" {
  name     = var.rgn
  location = var.location
}

# Storage account
resource "azurerm_storage_account" "example" {
  name                     = lower(var.storageaccountname)
  count=var.countvalue
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

