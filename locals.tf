locals {
  sbdvm = {
    vmname = "sbd-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slessbdimage/versions/1.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slessbdimage/versions/1.0.0"
    vmpip = "172.16.3.16"
    vmsize = "Standard_D2s_v3"
  }
  nfsvm0 = {
    vmname = "TST-nfs-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesnfsvm0/versions/2.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesnfsvm0/versions/1.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/images/TST-nfs-vm-0-image"
    vmpip = "172.16.3.12"
    vmsize = "Standard_D2s_v3"
    lbpip = "172.16.3.9"
  }  
  
  nfsvm1 = {
    vmname = "TST-nfs-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesnfsvm1/versions/2.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesnfsvm1/versions/1.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/images/TST-nfs-vm-1-image"
    vmpip = "172.16.3.11"
    vmsize = "Standard_D2s_v3"
  }  
 xscsvm0 = {
    vmname = "TST-xscs-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesxscs0/versions/2.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesxscs0/versions/1.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/images/TST-xscs-vm-0-image"
    vmpip = "172.16.3.15"
    vmsize = "Standard_D2s_v3"
    lbpip = "172.16.3.6"
  }  
 xscsvm1 = {
    vmname = "TST-xscs-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesxscs1/versions/2.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesxscs1/versions/1.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/images/TST-xscs-vm-1-image"
    vmpip = "172.16.3.14"
    vmsize = "Standard_D2s_v3"
    lbpip = "172.16.3.7"
  }  
 hanavm0 = {
    vmname = "TST-hana-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/sleshana/versions/2.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/images/TST-hana-vm-0-image"
    vmpip = "172.16.3.10"
    vmsize = "Standard_E8s_v3"
    lbpip = "172.16.3.8"
  }

 hanavm1 = {
    vmname = "TST-hana-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/sleshana1/versions/2.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/images/TST-hana-vm-1-image"
    vmpip = "172.16.3.13"
    vmsize = "Standard_E8s_v3"
  }    

 appvm = {
    vmname = "TST-app-avm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/galleries/s4sleshana/images/slesapp/versions/1.0.0"
    #vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sap-cluster-images/providers/Microsoft.Compute/images/TST-app-avm-0-image"
    vmpip = "172.16.3.5"
    vmsize = "Standard_D2s_v3"
  }  

}

