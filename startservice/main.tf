resource "azurerm_virtual_machine_extension" "pacemaker-vmext" {

    depends_on = ["var.vmext_depends_on"]    
    count =  "${ ("${var.vmtype}" == "app") ? "0":"1"}"
    name                 = "${var.vmname}"
    location             = "${var.location}"
    resource_group_name  = "${var.rgname}"
    virtual_machine_name = "${var.vmname}"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    settings = <<SETTINGS
    {
      "commandToExecute" : "[ crm cluster stop ; crm cluster start ; crm cluster status >> /tmp/output.txt]"
    }
    SETTINGS
}

resource "azurerm_virtual_machine_extension" "startapp-vmext" {

    depends_on = ["var.vmext_depends_on"]  
    count =  "${ ("${var.vmtype}" == "app") ? "1":"0"}"
    name                 = "${var.vmname}"
    location             = "${var.location}"
    resource_group_name  = "${var.rgname}"
    virtual_machine_name = "${var.vmname}"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    settings = <<SETTINGS
    {
      "commandToExecute" : "[ su - tstadm -c \"/usr/sap/TST/D00/exe/sapcontrol -nr 00 -function StartService TST \" ; su - tstadm -c \"/usr/sap/TST/D00/exe/sapcontrol -nr 00 -function Start\" ]"
    }
    SETTINGS
}