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

# NSG rules for web subnet
#NSG FOR WEB SUBNET
resource "azurerm_network_security_rule" "web_http" {
  name                        = "Allow-HTTP"
  network_security_group_name = azurerm_network_security_group.web.name
  resource_group_name         = azurerm_resource_group.main.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "web_https" {
  name                        = "Allow-HTTPS"
  network_security_group_name = azurerm_network_security_group.web.name
  resource_group_name         = azurerm_resource_group.main.name
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

#NSG FOR APP SUBNET
resource "azurerm_network_security_rule" "app_internal" {
  name                        = "Allow-Internal"
  network_security_group_name = azurerm_network_security_group.app.name
  resource_group_name         = azurerm_resource_group.main.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = var.web_subnet_cidr
  destination_address_prefix  = "*"
}

#NSG ASSOCIATIONS
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}
