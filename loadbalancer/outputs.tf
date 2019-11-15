output "lboutput" {
 description = "Output load balancer details to create dependancy between cluster components"
  value = "${azurerm_lb.sap-lb.id}"
}