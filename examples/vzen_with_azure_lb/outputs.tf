output "arm_resource_group" {
  description = "Azure Resource Group"
  value       = module.network.resource_group_name
}
output "management_public_ip_addresses" {
  description = "Azure Public IP Address"
  value       = module.network.management_public_ip_address[*]
}

output "load_balancer_public_ip" {
  description = "Azure LB Public IP Address"
  value       = var.lb_enabled ? module.network.load_balancer_public_ip_address : null
}

output "ssh_key_path" {
  description = "Path to SSH Private Key"
  value       = "../vzen-key-${var.resource_location}-${random_string.suffix.result}.pem"
}