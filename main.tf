provider "azurerm" {
  version = ">=1.22.0"
}
resource "azurerm_resource_group" "sap-cluster-openhack" {
    name = "${var.rgname}"
    location = "${var.location}"
  }
resource "azurerm_network_security_group" "sap-vm-nsg" {
    name = "nsg"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    resource_group_name = "${azurerm_resource_group.sap-cluster-openhack.name}"
}
resource "azurerm_network_security_rule" "ssh-access-rule" {
      name                        = "SSH"
      priority                    = 100
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "22"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      resource_group_name         = "${azurerm_resource_group.sap-cluster-openhack.name}"
      network_security_group_name = "${azurerm_network_security_group.sap-vm-nsg.name}"
}
resource "azurerm_virtual_network" "sap-vnet" {
    name = "sap-vnet"
    resource_group_name = "${azurerm_resource_group.sap-cluster-openhack.name}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    address_space = "${var.vnetprefix}"
    }

resource "azurerm_subnet" "sap-subnet" {
        name = "sap-subnet"
        resource_group_name = "${azurerm_resource_group.sap-cluster-openhack.name}"
        virtual_network_name = "${azurerm_virtual_network.sap-vnet.name}"
        address_prefix = "${var.subnetprefix}"
}

resource "azurerm_subnet_network_security_group_association" "sap-ngs-assc" {
  subnet_id                 = "${azurerm_subnet.sap-subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sap-vm-nsg.id}"
}

module "nfs-lb"{
    source = "./loadbalancer"
    vmtype = "nfs"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    lbpip = "${local.nfsvm0.lbpip}"
    subnet = "${azurerm_subnet.sap-subnet.id}"
}

module "xscs-lb"{
    source = "./loadbalancer"
    vmtype = "xscs"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    lbpip = "${local.xscsvm0.lbpip}"
    subnet = "${azurerm_subnet.sap-subnet.id}"
}

/*module "ers-lb"{
    source = "./loadbalancer"
    vmtype = "ers"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    lbpip = "${local.xscsvm1.lbpip}"
    subnet = "${azurerm_subnet.sap-subnet.id}"
}*/

module "hana-lb" {
    source = "./loadbalancer"
    vmtype = "hana"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    lbpip = "${local.hanavm0.lbpip}"
    subnet = "${azurerm_subnet.sap-subnet.id}"
}

module "create_sbd_vm0" {
    source = "./createvm"
    vm_depends_on = ["sbdvm"]
    vmtype = "sbd"
    vmname = "${local.sbdvm.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.sbdvm.vmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.sbdvm.vmpip}"
    image_id = "${local.sbdvm.vmimage}"
    lbid = ""
}
module "create_nfs_vm0" {
    source = "./createvm"
    vm_depends_on = ["${module.create_sbd_vm0.vmoutput}","${module.nfs-lb.lboutput}"]
    vmtype = "nfs"
    vmname = "${local.nfsvm0.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.nfsvm0.vmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.nfsvm0.vmpip}"
    image_id = "${local.nfsvm0.vmimage}"
    lbid = "${module.nfs-lb.lboutput}"
}

module "create_nfs_vm1" {
    source = "./createvm"
    vm_depends_on = ["${module.create_sbd_vm0.vmoutput}","${module.nfs-lb.lboutput}"]
    vmname = "${local.nfsvm1.vmname}"
    vmtype = "nfs"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.nfsvm1.vmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.nfsvm1.vmpip}"
    image_id = "${local.nfsvm1.vmimage}"
    lbid = "${module.nfs-lb.lboutput}"
}
/*
module "pacemaker_nfs_vm0" {
    source = "./startservice"
    vmext_depends_on = ["${module.create_nfs_vm0.vmoutput}"]
    vmname = "${local.nfsvm0.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    vmtype = "nfs"
}

module "pacemaker_nfs_vm1" {
    source = "./startservice"
    vmext_depends_on = ["${module.create_nfs_vm1.vmoutput}"]
    vmname = "${local.nfsvm1.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    vmtype = "nfs"
}
*/

module "create_xscs_vm0" {
    source = "./createvm"
    vm_depends_on = ["${module.create_nfs_vm0.vmoutput}","${module.create_nfs_vm1.vmoutput}","${module.xscs-lb.lboutput}"]
    vmname = "${local.xscsvm0.vmname}"
    vmtype = "xscs"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.xscsvm0.vmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.xscsvm0.vmpip}"
    image_id = "${local.xscsvm0.vmimage}"
    lbid = "${module.xscs-lb.lboutput}"
}

module "create_xscs_vm1" {
    source = "./createvm"
    vm_depends_on = ["${module.create_nfs_vm0.vmoutput}","${module.create_nfs_vm1.vmoutput}","${module.xscs-lb.lboutput}"]
    vmname = "${local.xscsvm1.vmname}"
    vmtype = "xscs"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.xscsvm1.vmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.xscsvm1.vmpip}"
    image_id = "${local.xscsvm1.vmimage}"
    lbid = "${module.xscs-lb.lboutput}"
}

/*module "pacemaker_xscs_vm0" {
    source = "./startservice"
    vmext_depends_on = ["${module.create_xscs_vm0.vmoutput}","${module.create_xscs_vm1.vmoutput}","${module.pacemaker_nfs_vm0.vmoutput}","${module.pacemaker_nfs_vm1.vmoutput}"]
    vmname = "${local.xscsvm0.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    vmtype = "xscs"
}

module "pacemaker_xscs_vm1" {
    source = "./startservice"
    vmext_depends_on = ["${module.create_xscs_vm0.vmoutput}","${module.create_xscs_vm1.vmoutput}","${module.pacemaker_nfs_vm0.vmoutput}","${module.pacemaker_nfs_vm1.vmoutput}"]
    vmname = "${local.xscsvm1.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    vmtype = "xscs"
}
*/


module "create_hana_vm0" {
    source = "./createvm"
    vm_depends_on = ["${module.create_sbd_vm0.vmoutput}","${module.hana-lb.lboutput}"]
    vmname = "${local.hanavm0.vmname}"
    vmtype = "hana"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.hanavm0.vmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.hanavm0.vmpip}"
    image_id = "${local.hanavm0.vmimage}"
    lbid = "${module.hana-lb.lboutput}"
}

module "create_hana_vm1" {
    source = "./createvm"
    vm_depends_on = ["${module.create_sbd_vm0.vmoutput}","${module.hana-lb.lboutput}"]
    vmname = "${local.hanavm1.vmname}"
    vmtype = "hana"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.hanavm1.vmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.hanavm1.vmpip}"
    image_id = "${local.hanavm1.vmimage}"
    lbid = "${module.hana-lb.lboutput}"
}

/*module "pacemaker_hana_vm0" {
    source = "./startservice"
    vmext_depends_on = ["${module.create_hana_vm0.vmoutput}","${module.create_hana_vm1.vmoutput}"]
    vmname = "${local.hanavm0.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    vmtype = "hana"
}

module "pacemaker_hana_vm1" {
    source = "./startservice"
    vmext_depends_on = ["${module.create_hana_vm0.vmoutput}","${module.create_hana_vm1.vmoutput}"]
    vmname = "${local.hanavm1.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    vmtype = "hana"
}
*/
module "create_app_vm" {
    source = "./createvm"
    vm_depends_on = ["${module.create_xscs_vm0.vmoutput}","${module.create_xscs_vm1.vmoutput}","${module.create_hana_vm0.vmoutput}","${module.create_hana_vm1.vmoutput}"]
    vmname = "${local.appvm.vmname}"
    vmtype = "app"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.appvm.vmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.appvm.vmpip}"
    image_id = "${local.appvm.vmimage}"
    lbid = ""
}

module "appstart_app_vm" {
    source = "./startservice"
    vmext_depends_on = ["${module.create_app_vm.vmoutput}"]
    vmname = "${local.appvm.vmname}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    vmtype = "app"
}


