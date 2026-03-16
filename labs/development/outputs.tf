output "subscription_id" {
 description = "azure sub id"
  value = data.azurerm_subscription.current.subscription_id
  sensitive = true
}

output "tenant_id" {
    description = "azure tenant ID"
  value = data.azurerm_subscription.current.tenant_id
  sensitive = true
}

output "location_info" {
  description = "azure location information"
  value = data.azurerm_location.current.display_name
}

output "resource_group_id" {
  description = "azure resource group id"
  value = data.azurerm_resource_group.development.id


}