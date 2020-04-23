resource "azurerm_lb_backend_address_pool" "lb_pool" {
  count = "${var.vmtype == "sbd" ? "0" : var.vmtype == "app" ? "0" : var.vmtype == "jbvm" ? "0" : "1"}"  
  resource_group_name = "${var.rgname}"
  loadbalancer_id     = "${var.lbid}"
  name                = "${var.vmtype}-BackEndAddressPool"
}

resource "azurerm_availability_set" "avset" {
    resource_group_name = "${var.rgname}"
    location = "${var.location}"
    managed = "true"
    platform_fault_domain_count = 2
    name =   "${var.vmtype}-avset"
}

resource "azurerm_public_ip" "jb-pip" {
    count = "${var.vmtype == "jbvm" ? "1" : "0"}"  
    depends_on = ["var.vm_depends_on"]
    name = "${var.vmname}-pip"
    location = "${var.location}"
    resource_group_name = "${var.rgname}"
    allocation_method = "Dynamic"
}
resource "azurerm_network_interface" "sapnw-nic" {
      count = "${var.vmtype == "jbvm" ? "0" : "1"}"  
      name = "${var.vmname}"
      location  = "${var.location}"
      resource_group_name = "${var.rgname}"
      ip_configuration {
          name = "${var.vmname}-ipconfig"
          subnet_id = "${var.subnet_id}"
          private_ip_address_allocation = "Static"
          private_ip_address = "${var.private_ip}"
          //public_ip_address_id = "${azurerm_public_ip.jb-pip.id}"
          //load_balancer_backend_address_pools_ids = ["${element(azurerm_lb_backend_address_pool.lb_pool.*.id,count.index)}"]
          load_balancer_backend_address_pools_ids = "${azurerm_lb_backend_address_pool.lb_pool.*.id}"
      }
        enable_accelerated_networking = "${var.vmtype == "hana" ? "true" : "false"}"
}

resource "azurerm_network_interface" "jb-nic" {
      count = "${var.vmtype == "jbvm" ? "1" : "0"}"  
      name = "${var.vmname}"
      location  = "${var.location}"
      resource_group_name = "${var.rgname}"
      ip_configuration {
          name = "${var.vmname}-ipconfig"
          subnet_id = "${var.subnet_id}"
          private_ip_address_allocation = "Static"
          private_ip_address = "${var.private_ip}"
          public_ip_address_id = "${azurerm_public_ip.jb-pip.0.id}"
          //load_balancer_backend_address_pools_ids = ["${element(azurerm_lb_backend_address_pool.lb_pool.*.id,count.index)}"]
          //load_balancer_backend_address_pools_ids = "${azurerm_lb_backend_address_pool.lb_pool.*.id}"
      }
        enable_accelerated_networking = "${var.vmtype == "hana" ? "true" : "false"}"
}

/*resource "azurerm_network_interface_backend_address_pool_association" "sapnw-assc" {
  count = "${var.vmtype == "sbd" ? "0" : var.vmtype == "app" ? "0" : "1"}"  
  network_interface_id    = "${azurerm_network_interface.sapnw-nic.id}"
  ip_configuration_name   = "${var.vmtype}-frontend"
  backend_address_pool_id = "${data.azurerm_lb_backend_address_pool.bpool.0.id}"
}
*/

resource "azurerm_virtual_machine" "sapnw-vm" {
     count = "${var.vmtype == "jbvm" ? "0" : "1"}"  
     name = "${var.vmname}"
     location = "${var.location}"
     resource_group_name = "${var.rgname}"
     network_interface_ids = ["${azurerm_network_interface.sapnw-nic[count.index].id}"]
     vm_size = "${var.vmsize}"
     availability_set_id = "${azurerm_availability_set.avset.id}"
     storage_image_reference {
         id = "${var.image_id}"
     }
      storage_os_disk {
            name = "${var.vmname}-osdisk"
            caching = "ReadWrite"
            create_option = "FromImage"
            managed_disk_type = "Premium_LRS"
        }
        os_profile {
            computer_name =  "${var.vmname}"
            admin_username = "${var.adminuser}"
            //admin_password = "${var.adminpassword}"
        }
        os_profile_linux_config{
            disable_password_authentication = "true"
               ssh_keys {
               key_data = file(var.sshkeypath)
               path = "/home/${var.adminuser}/.ssh/authorized_keys"
              } 
        }
}

resource "azurerm_virtual_machine" "jb-vm" {
     count = "${var.vmtype == "jbvm" ? "1" : "0"}"  
     name = "${var.vmname}"
     location = "${var.location}"
     resource_group_name = "${var.rgname}"
     network_interface_ids = ["${azurerm_network_interface.jb-nic[count.index].id}"]
     vm_size = "${var.vmsize}"
     availability_set_id = "${azurerm_availability_set.avset.id}"
     storage_image_reference {
         id = "${var.image_id}"
     }
      storage_os_disk {
            name = "${var.vmname}-osdisk"
            caching = "ReadWrite"
            create_option = "FromImage"
            managed_disk_type = "StandardSSD_LRS"
        }
        os_profile {
            computer_name =  "${var.vmname}"
            admin_username = "${var.adminuser}"
            admin_password = "${var.adminpassword}"
        }
        os_profile_windows_config {
            provision_vm_agent        = "true"
            enable_automatic_upgrades = "false"
  }
}
