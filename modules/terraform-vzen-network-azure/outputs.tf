output "resource_group_name" {
  description = "Azure Resource Group Name"
  value       = var.byo_rg ? data.azurerm_resource_group.rg_selected[0].name : azurerm_resource_group.rg[0].name
}

output "management_public_ip_address_ids" {
  description = "Azure Management Public IP Address ID(s)"
  value       = azurerm_public_ip.vzen_mgmt_public_ip[*].id
}

output "service_public_ip_address_ids" {
  description = "Azure Service Public IP Address"
  value       = azurerm_public_ip.vzen_service_public_ip[*].id
}

output "virtual_network_id" {
  description = "Azure Virtual Network ID"
  value       = var.byo_vnet ? data.azurerm_virtual_network.vnet_selected[0].id : azurerm_virtual_network.vnet[0].id
}

output "subnet_ids" {
  description = "Azure subnet ID(s)"
  value       = data.azurerm_subnet.vzen_subnet_selected[*].id
}

output "management_public_ip_address" {
  description = "Azure Management Public IP Address"
  value       = azurerm_public_ip.vzen_mgmt_public_ip[*].ip_address
}

output "load_balancer_public_ip_address_ids" {
  description = "Azure LB Public IP ID"
  value       = var.lb_enabled ? azurerm_public_ip.vzen_lb_public_ip[0].id : null
}

output "load_balancer_public_ip_address" {
  description = "Azure LB Public IP Address"
  value       = var.lb_enabled ? azurerm_public_ip.vzen_lb_public_ip[0].ip_address : null
}