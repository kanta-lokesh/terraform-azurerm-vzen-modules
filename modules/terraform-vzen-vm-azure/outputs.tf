output "private_ip" {
  description = "Instance Management Interface Private IP Address"
  value       = azurerm_network_interface.vzen_mgmt_nic[*].private_ip_address
}

output "service_ip" {
  description = "Instance Service Interface Private IP Address"
  value       = azurerm_network_interface.vzen_service_nic[*].private_ip_address
}