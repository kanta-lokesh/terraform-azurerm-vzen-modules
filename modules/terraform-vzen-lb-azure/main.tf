################################################################################
# Create Standard Load Balancer
################################################################################
resource "azurerm_lb" "vzen_lb" {
  name                = "vzen-lb-${var.resource_location}-${var.resource_tag}"
  location            = var.resource_location
  resource_group_name = var.resource_group
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "vzen-lb-ip-${var.resource_location}-${var.resource_tag}"
    public_ip_address_id          = var.loadbalancer_public_ip
  }
  
  tags = var.global_tags
}

################################################################################
# Create backend address pool for load balancer
################################################################################
resource "azurerm_lb_backend_address_pool" "vzen_lb_backend_pool" {
  name            = "vzen-lb-backend-${var.resource_location}-${var.resource_tag}"
  loadbalancer_id = azurerm_lb.vzen_lb.id
}

################################################################################
# Define load balancer health probe parameters
################################################################################
resource "azurerm_lb_probe" "vzen_lb_probe" {
  name                = "vzen-lb-probe-${var.resource_location}-${var.resource_tag}"
  loadbalancer_id     = azurerm_lb.vzen_lb.id
  protocol            = "Tcp"
  port                = var.lb_health_port
  interval_in_seconds = var.health_check_interval
  probe_threshold     = var.probe_threshold
  number_of_probes    = var.number_of_probes
}

################################################################################
# Create load balancer rule
################################################################################
resource "azurerm_lb_rule" "vzen_lb_rule" {
  name                           = "vzen-lb-rule-${var.resource_location}-${var.resource_tag}"
  loadbalancer_id                = azurerm_lb.vzen_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.vzen_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.vzen_lb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.vzen_lb_backend_pool.id]
}