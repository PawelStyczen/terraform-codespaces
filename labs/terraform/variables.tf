variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["192.168.0.0/16"]
}

variable "environment" {
  description = "environment name for tagging."
  type        = string
  default     = "learning-terraform"
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
  default     = "eastus"
}

# SUBNET VARIABLES
variable "web_subnet_cidr" {
  description = "CIDR block for the web subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_cidr" {
  description = "CIDR block for the app subnet."
  type        = string
  default     = "10.0.2.0/24"
}