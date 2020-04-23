output "vmoutput" {
 description = "Output VM resource group to create dependancy between cluster components"
 //value = "${azurerm_virtual_machine.sapnw-vm.0.id}"
 //value = ["${azurerm_virtual_machine.jb-vm.*.id}","${azurerm_virtual_machine.sapnw-vm.*.id}"]
 //value = "${join("${azurerm_virtual_machine.jb-vm.0.id}","${azurerm_virtual_machine.sapnw-vm.0.id}")}"
 value = "${element(compact(concat("${azurerm_virtual_machine.jb-vm.*.id}","${azurerm_virtual_machine.sapnw-vm.*.id}")),0)}"
 }
