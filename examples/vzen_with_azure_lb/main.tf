resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "tls_private_key" "key" {
  algorithm = var.tls_key_algorithm
}


locals {
  global_tags = var.user_defined_tags
}


resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "../vzen-key-${var.resource_location}-${random_string.suffix.result}.pem"
  file_permission = "0600"
}


module "network" {
  source                = "../../modules/terraform-vzen-network-azure"
  global_tags           = local.global_tags
  vzen_count            = var.vzen_count
  resource_location     = var.resource_location
  network_address_space = var.network_address_space
  zones_enabled         = var.zones_enabled
  zones                 = var.zones
  lb_enabled            = var.lb_enabled
  resource_tag          = random_string.suffix.result

  #bring-your-own variables
  byo_rg                             = var.byo_rg
  byo_rg_name                        = var.byo_rg_name
  byo_vnet                           = var.byo_vnet
  byo_vnet_name                      = var.byo_vnet_name
  byo_subnets                        = var.byo_subnets
  byo_subnet_names                   = var.byo_subnet_names
  byo_vnet_subnets_rg_name           = var.byo_vnet_subnets_rg_name
}


module "vzen_nsg" {
  source                      = "../../modules/terraform-vzen-nsg-azure"
  global_tags                 = local.global_tags
  nsg_count                   = var.reuse_nsg == false ? var.vzen_count : 1
  resource_group              = var.byo_nsg == false ? module.network.resource_group_name : var.byo_nsg_rg
  resource_location           = var.resource_location
  resource_tag                = random_string.suffix.result
  allow_ssh_from_existing_ips = var.allow_ssh_from_existing_ips
  allowed_ips_for_ssh         = var.allowed_ips_for_ssh

  byo_nsg                = var.byo_nsg
  # optional inputs. only required if byo_nsg set to true
  byo_mgmt_nsg_names     = var.byo_mgmt_nsg_names
  byo_service_nsg_names  = var.byo_service_nsg_names
}


module "vzen_vm" {
  source                         = "../../modules/terraform-vzen-vm-azure"
  global_tags                    = local.global_tags
  vzen_count                     = var.vzen_count
  resource_group                 = module.network.resource_group_name
  ssh_key                        = tls_private_key.key.public_key_openssh
  resource_location              = var.resource_location
  vzen_image_publisher           = var.vzen_image_publisher
  vzen_image_offer               = var.vzen_image_offer
  vzen_image_sku                 = var.vzen_image_sku
  vzen_image_version             = var.vzen_image_version
  vzen_source_image_id           = var.vzen_source_image_id
  vzen_vm_size                   = var.vzen_vm_size
  mgmt_nsg_id                    = module.vzen_nsg.mgmt_nsg_id
  service_nsg_id                 = module.vzen_nsg.service_nsg_id
  subnet_ids                     = module.network.subnet_ids
  management_public_ip           = module.network.management_public_ip_address_ids
  service_public_ip              = module.network.service_public_ip_address_ids
  zones_enabled                  = var.zones_enabled
  zones                          = var.zones
  lb_enabled                     = var.lb_enabled
  backend_address_pool           = module.vzen_lb.lb_backend_address_pool
  resource_tag                   = random_string.suffix.result
}

module "vzen_lb" {
  source                 = "../../modules/terraform-vzen-lb-azure"
  global_tags            = local.global_tags
  resource_group         = module.network.resource_group_name
  resource_location      = var.resource_location
  zones_enabled          = var.zones_enabled
  zones                  = var.zones
  health_check_interval  = var.health_check_interval
  probe_threshold        = var.probe_threshold
  number_of_probes       = var.number_of_probes
  loadbalancer_public_ip = module.network.load_balancer_public_ip_address_ids
  lb_health_port         = var.lb_health_port
  resource_tag           = random_string.suffix.result
}