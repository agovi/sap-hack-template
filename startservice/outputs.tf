output "vmoutput" {
 description = "Output VM resource group to create dependancy between cluster components"
  value = "${azurerm_virtual_machine_extension.pacemaker-vmext.*.id}"
}
