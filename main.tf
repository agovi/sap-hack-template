provider "azurerm" {
  version = "=1.34.0"
}
resource "azurerm_resource_group" "sap-cluster-openhack" {
  name     = "${var.rgname}"
  location = "${var.location}"
}
resource "azurerm_network_security_group" "hub-nsg" {
  name                = "hub-nsg"
  location            = "${azurerm_resource_group.sap-cluster-openhack.location}"
  resource_group_name = "${azurerm_resource_group.sap-cluster-openhack.name}"
}
resource "azurerm_network_security_group" "sap-vm-nsg" {
  name                = "sap-nsg"
  location            = "${azurerm_resource_group.sap-cluster-openhack.location}"
  resource_group_name = "${azurerm_resource_group.sap-cluster-openhack.name}"
}

resource "azurerm_network_security_rule" "rdp-access-rule" {
  name                        = "RDP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.sap-cluster-openhack.name}"
  network_security_group_name = "${azurerm_network_security_group.hub-nsg.name}"
}

resource "azurerm_network_security_rule" "ssh-access-rule" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "172.16.3.64/26"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.sap-cluster-openhack.name}"
  network_security_group_name = "${azurerm_network_security_group.sap-vm-nsg.name}"
}

resource "azurerm_network_security_rule" "sap-access-rule" {
  name                        = "SAP ports"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["3200", "3600", "3900", "3300"]
  source_address_prefix       = "172.16.3.64/26"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.sap-cluster-openhack.name}"
  network_security_group_name = "${azurerm_network_security_group.sap-vm-nsg.name}"
}

resource "azurerm_network_security_rule" "HANA-access-rule" {
  name                        = "HANA ports"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["30015", "50013", "50014"]
  source_address_prefix       = "172.16.3.64/26"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.sap-cluster-openhack.name}"
  network_security_group_name = "${azurerm_network_security_group.sap-vm-nsg.name}"
}

resource "azurerm_virtual_network" "sap-vnet" {
  name                = "sap-vnet"
  resource_group_name = "${azurerm_resource_group.sap-cluster-openhack.name}"
  location            = "${azurerm_resource_group.sap-cluster-openhack.location}"
  address_space       = "${var.vnetprefix}"
}

resource "azurerm_subnet" "hub-subnet" {
  name                 = "hub-subnet"
  resource_group_name  = "${azurerm_resource_group.sap-cluster-openhack.name}"
  virtual_network_name = "${azurerm_virtual_network.sap-vnet.name}"
  address_prefix       = "${var.hubsubnetprefix}"
}

resource "azurerm_subnet" "sap-subnet" {
  name                 = "sap-subnet"
  resource_group_name  = "${azurerm_resource_group.sap-cluster-openhack.name}"
  virtual_network_name = "${azurerm_virtual_network.sap-vnet.name}"
  address_prefix       = "${var.subnetprefix}"
}

resource "azurerm_subnet_network_security_group_association" "hub-nsg-assc" {
  subnet_id                 = "${azurerm_subnet.hub-subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.hub-nsg.id}"
}

resource "azurerm_subnet_network_security_group_association" "sap-nsg-assc" {
  subnet_id                 = "${azurerm_subnet.sap-subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sap-vm-nsg.id}"
}

module "nfs-lb" {
  source   = "./loadbalancer"
  vmtype   = "nfs"
  location = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname   = "${azurerm_resource_group.sap-cluster-openhack.name}"
  lbpip    = "${var.lb_config["nfspip"]}"
  subnet   = "${azurerm_subnet.sap-subnet.id}"
}

module "xscs-lb" {
  source   = "./loadbalancer"
  vmtype   = "xscs"
  location = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname   = "${azurerm_resource_group.sap-cluster-openhack.name}"
  lbpip    = "${var.lb_config["xscspip"]}"
  subnet   = "${azurerm_subnet.sap-subnet.id}"
}

module "hana-lb" {
  source   = "./loadbalancer"
  vmtype   = "hana"
  location = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname   = "${azurerm_resource_group.sap-cluster-openhack.name}"
  lbpip    = "${var.lb_config["hanapip"]}"
  subnet   = "${azurerm_subnet.sap-subnet.id}"
}

module "create_jb_vm0" {
  source        = "./createvm"
  vm_depends_on = ["jbvm"]
  vmtype        = "jbvm"
  vmname        = "${var.jb_config["vmname"]}"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.hub-subnet.id}"
  vmsize        = "${var.jb_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.jb_config["privateip"]}"
  image_id   = "${var.jb_config["imageid"]}"
  lbid       = ""
}
/*
module "create_sbd_vm0" {
  source        = "./createvm"
  vm_depends_on = ["sbdvm"]
  vmtype        = "sbd"
  vmname        = "${var.sbd_config["vmname"]}"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.sap-subnet.id}"
  vmsize        = "${var.sbd_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.sbd_config["privateip"]}"
  image_id   = "${var.sbd_config["imageid"]}"
  lbid       = ""
}
module "create_nfs_vm0" {
  source        = "./createvm"
  vm_depends_on = ["${module.create_sbd_vm0.vmoutput}", "${module.nfs-lb.lboutput}"]
  vmtype        = "nfs"
  vmname        = "${var.nfs_node0_config["vmname"]}"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.sap-subnet.id}"
  vmsize        = "${var.nfs_node0_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.nfs_node0_config["privateip"]}"
  image_id   = "${var.nfs_node0_config["imageid"]}"
  lbid       = "${module.nfs-lb.lboutput}"
}

module "create_nfs_vm1" {
  source        = "./createvm"
  vm_depends_on = ["${module.create_sbd_vm0.vmoutput}", "${module.nfs-lb.lboutput}"]
  vmname        = "${var.nfs_node1_config["vmname"]}"
  vmtype        = "nfs"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.sap-subnet.id}"
  vmsize        = "${var.nfs_node1_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.nfs_node1_config["privateip"]}"
  image_id   = "${var.nfs_node1_config["imageid"]}"
  lbid       = "${module.nfs-lb.lboutput}"
}

module "pacemaker_nfs_vm0" {
  source           = "./startservice"
  vmext_depends_on = ["${module.create_nfs_vm0.vmoutput}", "${module.create_nfs_vm1.vmoutput}"]
  vmname           = "${var.nfs_node0_config["vmname"]}"
  location         = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname           = "${azurerm_resource_group.sap-cluster-openhack.name}"
  vmtype           = "nfs"
}

module "pacemaker_nfs_vm1" {
  source           = "./startservice"
  vmext_depends_on = ["${module.create_nfs_vm0.vmoutput}", "${module.create_nfs_vm1.vmoutput}"]
  vmname           = "${var.nfs_node1_config["vmname"]}"
  location         = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname           = "${azurerm_resource_group.sap-cluster-openhack.name}"
  vmtype           = "nfs"
}


module "create_xscs_vm0" {
  source        = "./createvm"
  vm_depends_on = ["${module.create_nfs_vm0.vmoutput}", "${module.create_nfs_vm1.vmoutput}", "${module.xscs-lb.lboutput}"]
  vmname        = "${var.xscs_node0_config["vmname"]}"
  vmtype        = "xscs"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.sap-subnet.id}"
  vmsize        = "${var.xscs_node0_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.xscs_node0_config["privateip"]}"
  image_id   = "${var.xscs_node0_config["imageid"]}"
  lbid       = "${module.xscs-lb.lboutput}"
}

module "create_xscs_vm1" {
  source        = "./createvm"
  vm_depends_on = ["${module.create_nfs_vm0.vmoutput}", "${module.create_nfs_vm1.vmoutput}", "${module.xscs-lb.lboutput}"]
  vmname        = "${var.xscs_node1_config["vmname"]}"
  vmtype        = "xscs"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.sap-subnet.id}"
  vmsize        = "${var.xscs_node1_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.xscs_node1_config["privateip"]}"
  image_id   = "${var.xscs_node1_config["imageid"]}"
  lbid       = "${module.xscs-lb.lboutput}"
}

module "pacemaker_xscs_vm0" {
  source           = "./startservice"
  vmext_depends_on = ["${module.create_xscs_vm0.vmoutput}", "${module.create_xscs_vm1.vmoutput}", "${module.pacemaker_nfs_vm0.vmoutput}", "${module.pacemaker_nfs_vm1.vmoutput}"]
  vmname           = "${var.xscs_node0_config["vmname"]}"
  location         = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname           = "${azurerm_resource_group.sap-cluster-openhack.name}"
  vmtype           = "xscs"
}

module "pacemaker_xscs_vm1" {
  source           = "./startservice"
  vmext_depends_on = ["${module.create_xscs_vm0.vmoutput}", "${module.create_xscs_vm1.vmoutput}", "${module.pacemaker_nfs_vm0.vmoutput}", "${module.pacemaker_nfs_vm1.vmoutput}"]
  vmname           = "${var.xscs_node1_config["vmname"]}"
  location         = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname           = "${azurerm_resource_group.sap-cluster-openhack.name}"
  vmtype           = "xscs"
}

module "create_hana_vm0" {
  source        = "./createvm"
  vm_depends_on = ["${module.create_sbd_vm0.vmoutput}", "${module.hana-lb.lboutput}"]
  vmname        = "${var.hana_node0_config["vmname"]}"
  vmtype        = "hana"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.sap-subnet.id}"
  vmsize        = "${var.hana_node0_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.hana_node0_config["privateip"]}"
  image_id   = "${var.hana_node0_config["imageid"]}"
  lbid       = "${module.hana-lb.lboutput}"
}

module "create_hana_vm1" {
  source        = "./createvm"
  vm_depends_on = ["${module.create_sbd_vm0.vmoutput}", "${module.hana-lb.lboutput}"]
  vmname        = "${var.hana_node1_config["vmname"]}"
  vmtype        = "hana"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.sap-subnet.id}"
  vmsize        = "${var.hana_node1_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.hana_node1_config["privateip"]}"
  image_id   = "${var.hana_node1_config["imageid"]}"
  lbid       = "${module.hana-lb.lboutput}"
}

module "pacemaker_hana_vm0" {
  source           = "./startservice"
  vmext_depends_on = ["${module.create_hana_vm0.vmoutput}", "${module.create_hana_vm1.vmoutput}"]
  vmname           = "${var.hana_node0_config["vmname"]}"
  location         = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname           = "${azurerm_resource_group.sap-cluster-openhack.name}"
  vmtype           = "hana"
}

module "pacemaker_hana_vm1" {
  source           = "./startservice"
  vmext_depends_on = ["${module.create_hana_vm0.vmoutput}", "${module.create_hana_vm1.vmoutput}"]
  vmname           = "${var.hana_node1_config["vmname"]}"
  location         = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname           = "${azurerm_resource_group.sap-cluster-openhack.name}"
  vmtype           = "hana"
}

module "create_app_vm" {
  source        = "./createvm"
  vm_depends_on = ["${module.pacemaker_hana_vm0.vmoutput}", "${module.pacemaker_hana_vm1.vmoutput}", "${module.pacemaker_xscs_vm0.vmoutput}", "${module.pacemaker_xscs_vm1.vmoutput}"]
  vmname        = "${var.app_config["vmname"]}"
  vmtype        = "app"
  location      = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname        = "${azurerm_resource_group.sap-cluster-openhack.name}"
  subnet_id     = "${azurerm_subnet.sap-subnet.id}"
  vmsize        = "${var.app_config["vmsize"]}"
  adminuser     = "${var.adminuser}"
  //adminpassword = "${var.adminpassword}"
  sshkeypath = "${var.sshkeypath}"
  private_ip = "${var.app_config["privateip"]}"
  image_id   = "${var.app_config["imageid"]}"
  lbid       = ""
}

module "appstart_app_vm" {
  source           = "./startservice"
  vmext_depends_on = ["${module.create_app_vm.vmoutput}"]
  vmname           = "${var.app_config["vmname"]}"
  location         = "${azurerm_resource_group.sap-cluster-openhack.location}"
  rgname           = "${azurerm_resource_group.sap-cluster-openhack.name}"
  vmtype           = "app"
}


*/