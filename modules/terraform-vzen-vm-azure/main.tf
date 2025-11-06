################################################################################
# Create VZEN Management Interfaces and associate NSG
################################################################################
# Create VZEN Management interfaces
resource "azurerm_network_interface" "vzen_mgmt_nic" {
  count               = var.vzen_count
  name                = "vzen-${count.index + 1}-mgmt-nic-${var.resource_location}-${var.resource_tag}"
  location            = var.resource_location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "vzen-${count.index + 1}-mgmt-nic-conf-${var.resource_location}-${var.resource_tag}"
    subnet_id                     = element(var.subnet_ids, count.index)
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = element(var.management_public_ip, count.index)
  }
  tags = var.global_tags
}


################################################################################
# Associate VZEN Management interface to Management NSG
################################################################################
resource "azurerm_network_interface_security_group_association" "vzen_mgmt_nic_association" {
  count                     = var.vzen_count
  network_interface_id      = azurerm_network_interface.vzen_mgmt_nic[count.index].id
  network_security_group_id = element(var.mgmt_nsg_id, count.index)

  depends_on = [azurerm_network_interface.vzen_mgmt_nic]
}


################################################################################
# Create VZEN Service Interfaces for Small VZEN sizes.
# This interface becomes LB0 interface for Medium/Large VZEN sizes
################################################################################
resource "azurerm_network_interface" "vzen_service_nic" {
  count                          = var.vzen_count
  name                           = "vzen-${count.index + 1}-service-nic-${var.resource_location}-${var.resource_tag}"
  location                       = var.resource_location
  resource_group_name            = var.resource_group
  ip_forwarding_enabled          = true

  ip_configuration {
    name                          = "vzen-${count.index + 1}-service-nic-conf-${var.resource_location}-${var.resource_tag}"
    subnet_id                     = element(var.subnet_ids, count.index)
    private_ip_address_allocation = "Dynamic"
    primary                       = false
    public_ip_address_id          = element(var.service_public_ip, count.index)
  }

  tags = var.global_tags

  depends_on = [azurerm_network_interface.vzen_mgmt_nic]
}


################################################################################
# Associate VZEN Service/Forwarding NIC to Service NSG
################################################################################
resource "azurerm_network_interface_security_group_association" "vzen_service_nic_association" {
  count                     = var.vzen_count
  network_interface_id      = azurerm_network_interface.vzen_service_nic[count.index].id
  network_security_group_id = element(var.service_nsg_id, count.index)

  depends_on = [azurerm_network_interface.vzen_service_nic]
}


################################################################################
# Create VZEN Network Interface to Load Balancer associations
################################################################################
# Associate VZEN forwarding interface to Azure LB backend pool
resource "azurerm_network_interface_backend_address_pool_association" "vzen_vm_service_nic_lb_association" {
  count                   = var.lb_enabled == true ? var.vzen_count : 0
  network_interface_id    = azurerm_network_interface.vzen_service_nic[count.index].id
  ip_configuration_name   = "vzen-${count.index + 1}-service-nic-conf-${var.resource_location}-${var.resource_tag}"
  backend_address_pool_id = var.backend_address_pool

  depends_on = [var.backend_address_pool]
}

################################################################################
# Create VZEN VM
################################################################################
resource "azurerm_linux_virtual_machine" "vzen_vm" {
  count                      = var.vzen_count
  name                       = "vzen-${count.index + 1}-${var.resource_location}-${var.resource_tag}"
  location                   = var.resource_location
  resource_group_name        = var.resource_group
  size                       = var.vzen_vm_size
  availability_set_id        = local.zones_supported == false ? azurerm_availability_set.vzen_availability_set[0].id : null
  zone                       = local.zones_supported ? element(var.zones, count.index) : null

  network_interface_ids = [
    azurerm_network_interface.vzen_mgmt_nic[count.index].id,
    azurerm_network_interface.vzen_service_nic[count.index].id,
  ]

  computer_name  = "vzen-${count.index + 1}-${var.resource_location}-${var.resource_tag}"
  admin_username = "zsroot"

  disable_password_authentication = true
  admin_ssh_key {
    username   = "zsroot"
    public_key = "${trimspace(var.ssh_key)}"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  dynamic "source_image_reference" {
    for_each = var.vzen_source_image_id == null ? [var.vzen_image_publisher] : []

    content {
      publisher = var.vzen_image_publisher
      offer     = var.vzen_image_offer
      sku       = var.vzen_image_sku
      version   = var.vzen_image_version
    }
  }

  dynamic "plan" {
    for_each = var.vzen_source_image_id == null ? [var.vzen_image_publisher] : []

    content {
      publisher = var.vzen_image_publisher
      name      = var.vzen_image_sku
      product   = var.vzen_image_offer
    }
  }

  source_image_id = var.vzen_source_image_id != null ? var.vzen_source_image_id : null

  tags = var.global_tags

  depends_on = [
    azurerm_network_interface_security_group_association.vzen_mgmt_nic_association,
    azurerm_network_interface_security_group_association.vzen_service_nic_association,
    azurerm_network_interface_backend_address_pool_association.vzen_vm_service_nic_lb_association,
    var.backend_address_pool
  ]

  lifecycle {
    ignore_changes = [network_interface_ids]
  }
}


resource "azurerm_availability_set" "vzen_availability_set" {
  count                       = local.zones_supported == false ? 1 : 0
  name                        = "vzen-availability-set-${var.resource_location}-${var.resource_tag}"
  location                    = var.resource_location
  resource_group_name         = var.resource_group
  platform_fault_domain_count = local.max_fd_supported == true ? 3 : 2

  tags = var.global_tags
}