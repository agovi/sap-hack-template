locals {
  sbdvm = {
    vmname  = "sbd-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-images-rg/providers/Microsoft.Compute/galleries/s4hana1809.sles12/images/SBD/versions/1.0.0"
    vmpip   = "172.16.3.16"
    vmsize  = "Standard_D2s_v3"
  }
  nfsvm0 = {
    vmname  = "tst-nfs-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-images-rg/providers/Microsoft.Compute/galleries/s4hana1809.sles12/images/NFS-Node1/versions/1.0.0"
    vmpip   = "172.16.3.12"
    vmsize  = "Standard_D2s_v3"
    lbpip   = "172.16.3.9"
  }

  nfsvm1 = {
    vmname  = "tst-nfs-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-images-rg/providers/Microsoft.Compute/galleries/s4hana1809.sles12/images/NFS-Node2/versions/1.0.0"
    vmpip   = "172.16.3.11"
    vmsize  = "Standard_D2s_v3"
  }
  xscsvm0 = {
    vmname  = "tst-xscs-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-images-rg/providers/Microsoft.Compute/galleries/s4hana1809.sles12/images/SAP-ASCS-Node1/versions/1.0.0"
    vmpip   = "172.16.3.15"
    vmsize  = "Standard_D2s_v3"
    lbpip   = "172.16.3.6"
  }
  xscsvm1 = {
    vmname  = "tst-xscs-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-images-rg/providers/Microsoft.Compute/galleries/s4hana1809.sles12/images/SAP-ASCS-Node2/versions/1.0.0"
    vmpip   = "172.16.3.14"
    vmsize  = "Standard_D2s_v3"
    lbpip   = "172.16.3.7"
  }
  hanavm0 = {
    vmname  = "tst-hana-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-images-rg/providers/Microsoft.Compute/galleries/s4hana1809.sles12/images/HANA-Node1/versions/1.0.0"
    vmpip   = "172.16.3.10"
    vmsize  = "Standard_E8s_v3"
    lbpip   = "172.16.3.8"
  }

  hanavm1 = {
    vmname  = "tst-hana-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-images-rg/providers/Microsoft.Compute/galleries/s4hana1809.sles12/images/HANA-Node2/versions/1.0.0"
    vmpip   = "172.16.3.13"
    vmsize  = "Standard_E8s_v3"
  }

  appvm = {
    vmname  = "tst-app-avm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-images-rg/providers/Microsoft.Compute/galleries/s4hana1809.sles12/images/SAP-APP/versions/1.0.0"
    vmpip   = "172.16.3.5"
    vmsize  = "Standard_D2s_v3"
  }

}

