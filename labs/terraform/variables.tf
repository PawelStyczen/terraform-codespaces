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