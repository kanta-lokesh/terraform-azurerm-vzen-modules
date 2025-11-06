################################################################################
# Create NSG and Rules for VZEN Management interfaces
################################################################################
resource "azurerm_network_security_group" "vzen_mgmt_nsg" {
  count               = var.byo_nsg == false ? var.nsg_count : 0
  name                = "vzen-mgmt-nsg-${count.index + 1}-${var.resource_location}-${var.resource_tag}"
  location            = var.resource_location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "SSH_VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ICMP_VNET"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "OUTBOUND"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow SSH from existing IPs if enabled
  dynamic "security_rule" {
    for_each = var.allow_ssh_from_existing_ips ? var.allowed_ips_for_ssh : []
    content {
      name                       = "SSH_FROM_${replace(replace(security_rule.value, "/", "_"),".", "_")}"
      priority                   = 200 + index(var.allowed_ips_for_ssh, security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = security_rule.value
      destination_address_prefix = "*"
    }
  }

  tags = var.global_tags
}

# Or use existing Mgmt NSG
data "azurerm_network_security_group" "mgt_nsg_selected" {
  count               = var.byo_nsg ? length(var.byo_mgmt_nsg_names) : 0
  name                = var.byo_nsg ? element(var.byo_mgmt_nsg_names, count.index) : 0
  resource_group_name = var.resource_group
}


################################################################################
# Create NSG and Rules for VZEN Service interfaces
################################################################################
resource "azurerm_network_security_group" "vzen_service_nsg" {
  count               = var.byo_nsg == false ? var.nsg_count : 0
  name                = "vzen-service-nsg-${count.index + 1}-${var.resource_location}-${var.resource_tag}"
  location            = var.resource_location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "ALL_VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "OUTBOUND"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.global_tags
}

# Or use existing Service NSG
data "azurerm_network_security_group" "service_nsg_selected" {
  count               = var.byo_nsg ? length(var.byo_service_nsg_names) : 0
  name                = var.byo_nsg ? element(var.byo_service_nsg_names, count.index) : 0
  resource_group_name = var.resource_group
}