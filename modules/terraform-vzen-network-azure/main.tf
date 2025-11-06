################################################################################
# Resource Group
################################################################################
# Create Resource Group or reference existing
resource "azurerm_resource_group" "rg" {
  count    = var.byo_rg == false ? 1 : 0
  name     = "vzen-rg-${var.resource_location}-${var.resource_tag}"
  location = var.resource_location

  tags = var.global_tags
}

data "azurerm_resource_group" "rg_selected" {
  count = var.byo_rg ? 1 : 0
  name  = var.byo_rg_name
}


################################################################################
# Virtual Network
################################################################################
# Create Virtual Network or reference existing
resource "azurerm_virtual_network" "vnet" {
  count               = var.byo_vnet == false ? 1 : 0
  name                = "vzen-vnet-${var.resource_location}-${var.resource_tag}"
  address_space       = [var.network_address_space]
  location            = var.resource_location
  resource_group_name = try(data.azurerm_resource_group.rg_selected[0].name, azurerm_resource_group.rg[0].name)

  tags = var.global_tags
}

data "azurerm_virtual_network" "vnet_selected" {
  count               = var.byo_vnet ? 1 : 0
  name                = var.byo_vnet_name
  resource_group_name = var.byo_vnet_subnets_rg_name
}

################################################################################
# Create subnet
################################################################################
resource "azurerm_subnet" "vzen_subnet" {
  count                = var.byo_subnets == false ? length(distinct(var.zones)) : 0
  name                 = "vzen_subnet_${var.resource_location}_${count.index + 1}_${var.resource_tag}"
  resource_group_name  = var.byo_vnet == false ? try(data.azurerm_virtual_network.vnet_selected[0].resource_group_name, azurerm_virtual_network.vnet[0].resource_group_name) : var.byo_vnet_subnets_rg_name
  virtual_network_name = var.byo_vnet == false ? try(data.azurerm_virtual_network.vnet_selected[0].name, azurerm_virtual_network.vnet[0].name) : var.byo_vnet_name
  address_prefixes     = var.vzen_subnets != null ? [element(var.vzen_subnets, count.index)] :[cidrsubnet(try(data.azurerm_virtual_network.vnet_selected[0].address_space[0], var.network_address_space), 8, count.index + 200)]
}

data "azurerm_subnet" "vzen_subnet_selected" {
  count                = var.byo_subnets == false ? length(azurerm_subnet.vzen_subnet[*].id) : length(var.byo_subnet_names)
  name                 = var.byo_subnets == false ? azurerm_subnet.vzen_subnet[count.index].name : element(var.byo_subnet_names, count.index)
  resource_group_name  = var.byo_vnet == false ? try(data.azurerm_virtual_network.vnet_selected[0].resource_group_name, azurerm_virtual_network.vnet[0].resource_group_name) : var.byo_vnet_subnets_rg_name
  virtual_network_name = var.byo_vnet == false ? try(data.azurerm_virtual_network.vnet_selected[0].name, azurerm_virtual_network.vnet[0].name) : var.byo_vnet_name
}

################################################################################
# Create public IPs
################################################################################
resource "azurerm_public_ip" "vzen_mgmt_public_ip" {
  count               = var.vzen_count
  name                = "vzen_mgmt_public_ip_${var.resource_location}_${count.index + 1}_${var.resource_tag}"
  location            = var.resource_location
  resource_group_name = try(data.azurerm_resource_group.rg_selected[0].name, azurerm_resource_group.rg[0].name)
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = local.zones_supported ? [element(var.zones, count.index)] : null

  tags = var.global_tags
}

resource "azurerm_public_ip" "vzen_service_public_ip" {
  count               = var.vzen_count
  name                = "vzen_service_public_ip_${var.resource_location}_${count.index + 1}_${var.resource_tag}"
  location            = var.resource_location
  resource_group_name = try(data.azurerm_resource_group.rg_selected[0].name, azurerm_resource_group.rg[0].name)
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = local.zones_supported ? [element(var.zones, count.index)] : null

  tags = var.global_tags
}

resource "azurerm_public_ip" "vzen_lb_public_ip" {
  count                 = var.lb_enabled ? 1 : 0
  name                  = "vzen_lb_public_ip_${var.resource_tag}"
  location              = var.resource_location
  resource_group_name   = try(data.azurerm_resource_group.rg_selected[0].name, azurerm_resource_group.rg[0].name)
  allocation_method     = "Static"
  sku                   = "Standard"
  zones                 = local.zones_supported ? local.frontend_zone_specific : null

  tags = var.global_tags
}