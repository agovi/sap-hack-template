resource "azurerm_public_ip" "sapnw-pip" {
    name = "${var.vmname}-pip"
    location = "${var.location}"
    resource_group_name = "${var.rgname}"
    allocation_method = "Dynamic"
}
resource "azurerm_network_interface" "sapnw-nic" {
      name = "${var.vmname}"
      location  = "${var.location}"
      resource_group_name = "${var.rgname}"
      ip_configuration {
          name = "${var.vmname}-ipconfig"
          subnet_id = "${var.subnet_id}"
          private_ip_address_allocation = "Static"
          private_ip_address = "${var.private_ip}"
          public_ip_address_id = "${azurerm_public_ip.sapnw-pip.id}"
      }
        enable_accelerated_networking = "${var.vmtype == "hana" ? "true" : "false"}"
}

resource "azurerm_virtual_machine" "sapnw-vm" {
     name = "${var.vmname}"
     location = "${var.location}"
     resource_group_name = "${var.rgname}"
     network_interface_ids = ["${azurerm_network_interface.sapnw-nic.id}"]
     vm_size = "${var.vmsize}"
     storage_image_reference {
         id = "${var.image_id}"
     }
      storage_os_disk {
            name = "${var.vmname}-osdisk"
            caching = "ReadWrite"
            create_option = "FromImage"
            managed_disk_type = "Standard_LRS"
        }
        os_profile {
            computer_name =  "${var.vmname}"
            admin_username = "${var.adminuser}"
            admin_password = "${var.adminpassword}"
        }
        os_profile_linux_config{
            disable_password_authentication = "false"
        }
}
