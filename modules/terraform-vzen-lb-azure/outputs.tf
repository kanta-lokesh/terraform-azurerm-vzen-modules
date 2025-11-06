output "lb_backend_address_pool" {
  description = "Azure Load Balancer Backend Pool ID"
  value       = azurerm_lb_backend_address_pool.vzen_lb_backend_pool.id
}