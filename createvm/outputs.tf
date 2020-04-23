output "vmoutput" {
 description = "Output VM resource group to create dependancy between cluster components"
 //value = "${azurerm_virtual_machine.sapnw-vm.0.id}"
 value = "${var.vmtype == "jbvm" ? "" : "${azurerm_virtual_machine.sapnw-vm.0.id}" }"
 }
