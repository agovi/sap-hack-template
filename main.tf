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

module "create_sbd_vm0" {
    source = "./createvm"
    vmtype = "sbd"
    vmname = "${local.sbdvm}"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.nfsvmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.sbdpip}"
    image_id = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapdevopenhack/providers/Microsoft.Compute/images/sles12sp3-sbd-vm-0"
}


module "create_nfs_vm0" {
    source = "./createvm"
    vmtype = "nfs"
    vmname = "${local.nfsvm}-0"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.nfsvmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.nfspip0}"
    image_id = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapdevopenhack/providers/Microsoft.Compute/images/sles12sp3-nfs-vm-0"
}

module "create_nfs_vm1" {
    source = "./createvm"
    vmname = "${local.nfsvm}-1"
    vmtype = "nfs"
    location = "${azurerm_resource_group.sap-cluster-openhack.location}"
    rgname = "${azurerm_resource_group.sap-cluster-openhack.name}"
    subnet_id = "${azurerm_subnet.sap-subnet.id}"
    vmsize = "${local.nfsvmsize}"
    adminuser = "${var.adminuser}"
    adminpassword = "${var.adminpassword}"
    private_ip = "${local.nfspip1}"
    image_id = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapdevopenhack/providers/Microsoft.Compute/images/sles12sp3-nfs-vm-1"
}
