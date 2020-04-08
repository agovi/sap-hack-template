
resource "azurerm_lb" "sap-lb" {
    name = "${var.vmtype}-lb"
    location = "${var.location}"
    resource_group_name = "${var.rgname}"
    frontend_ip_configuration {
        name = "${var.vmtype}-frontend"
        subnet_id = "${var.subnet}"
        private_ip_address_allocation = "Static"
        private_ip_address = "${var.lbpip}"
    }
}

resource "azurerm_lb_backend_address_pool" "lb_pool" {
  resource_group_name = "${var.rgname}"
  loadbalancer_id     = "${azurerm_lb.sap-lb.id}"
  name                = "${var.vmtype}-BackEndAddressPool"
}

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = "${var.rgname}"
  loadbalancer_id     = "${azurerm_lb.sap-lb.id}"
  name                = "${var.vmtype}-probe"
  port                = "${var.vmtype == "nfs" ? "61000" : var.vmtype == "hana" ? "62503" : var.vmtype == "xscs" ? "62000" : "62110"}"
}

resource "azurerm_lb_rule" "lb_rule_nfs_20048T" {
  count = "${ ("${var.vmtype}" == "nfs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-20048"
  protocol                       = "tcp"
  frontend_port                  = 20048
  backend_port                   = 20048
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_nfs_20048U" {
  count = "${ ("${var.vmtype}" == "nfs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-20048-U"
  protocol                       = "udp"
  frontend_port                  = 20048
  backend_port                   = 20048
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_nfs_2049U" {
  count = "${ ("${var.vmtype}" == "nfs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-2049-U"
  protocol                       = "udp"
  frontend_port                  = 2049
  backend_port                   = 2049
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_nfs_2049T" {
  count = "${ ("${var.vmtype}" == "nfs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-2049-T"
  protocol                       = "tcp"
  frontend_port                  = 2049
  backend_port                   = 2049
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_hana" {
  count = "${ ("${var.vmtype}" == "hana") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-30013"
  protocol                       = "tcp"
  frontend_port                  = 30013
  backend_port                   = 30013
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
  idle_timeout_in_minutes        =  30
}

resource "azurerm_lb_rule" "lb_rule_hana_50013" {
  count = "${ ("${var.vmtype}" == "hana") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-50013"
  protocol                       = "tcp"
  frontend_port                  = 50013
  backend_port                   = 50013
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
  idle_timeout_in_minutes        =  30
}

resource "azurerm_lb_rule" "lb_rule_xscs_32xx" {
  count = "${ ("${var.vmtype}" == "xscs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-3200"
  protocol                       = "tcp"
  frontend_port                  = 3200
  backend_port                   = 3200
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_xscs_36xx" {
  count = "${ ("${var.vmtype}" == "xscs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-3600"
  protocol                       = "tcp"
  frontend_port                  = 3600
  backend_port                   = 3600
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_xscs_39xx" {
  count = "${ ("${var.vmtype}" == "xscs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-3900"
  protocol                       = "tcp"
  frontend_port                  = 3900
  backend_port                   = 3900
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_xscs_81xx" {
  count = "${ ("${var.vmtype}" == "xscs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-8100"
  protocol                       = "tcp"
  frontend_port                  = 8100
  backend_port                   = 8100
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_xscs_5xx13" {
  count = "${ ("${var.vmtype}" == "xscs") ? "1":"0"}"    
  resource_group_name            = "${var.rgname}"
  loadbalancer_id                = "${azurerm_lb.sap-lb.id}"
  name                           = "lb-50013"
  protocol                       = "tcp"
  frontend_port                  = 50013
  backend_port                   = 50013
  frontend_ip_configuration_name = "${var.vmtype}-frontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}