#get information about the current locations
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

# get location information
data "azurerm_location" "current" {
  location = "eastus"
}

# create resource group data source information
data "azurerm_resource_group" "development" {
  name     = "development-resources"
  location = data.azurerm_location.current.display_name

  tags = {
    environment    = "development"
    SubscriptionId = data.azurerm_subscription.current.subscription_id
    CreatedBy      = data.azurerm_client_config.current.object_id
  }
}

# Create Virtual Network using data source information
resource "azurerm_virtual_network" "development" {
  name                = "development-vnet"
  resource_group_name = data.azurerm_resource_group.development.name
  location            = data.azurerm_resource_group.development.location
  address_space       = [var.vnet_cidr]


  tags = {
    environment = "development"
    Location    = data.azurerm_location.current.display_name
    CreatedBy   = "${data.azurerm_subscription.current.subscription_id}-${data.azurerm_location.current.display_name}"
  }
}