# create a resource group
resource "azurerm_resource_group" "main" {
  name     = "terraform-course"
  location = var.location

  tags = {
    name        = "terraform-course"
    environment = var.environment
    Managed_By  = "Terraform"
  }
}

# create the virual network
resource "azurerm_virtual_network" "main" {
  name                = "terraform-network"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = var.vnet_address_space

  tags = {
    name        = "terraform-course"
    environment = var.environment
    Managed_By  = "Terraform"
  }
}

# CREATE SUBNETS
resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.web_subnet_cidr]
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.app_subnet_cidr]
}

# NETWORK SECURITY GROUP
resource "azurerm_network_security_group" "web" {
  name                = "web-nsg"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = {
    name        = "web-nsg"
    environment = var.environment
  }
}

resource "azurerm_network_security_group" "app" {
  name                = "app-nsg"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = {
    name        = "app-nsg"
    environment = var.environment
  }
}
