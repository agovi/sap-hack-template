locals {
  sbdvm = {
    vmname = "sbd-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapclusterhack/providers/Microsoft.Compute/images/sbd-vm-0-image-20200324111144"
    vmpip = "172.16.3.16"
    vmsize = "Standard_D2s_v3"
  }
  nfsvm0 = {
    vmname = "tst-nfs-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapclusterhack/providers/Microsoft.Compute/images/TST-nfs-vm-0-image-20200324111333"
    vmpip = "172.16.3.12"
    vmsize = "Standard_D2s_v3"
    lbpip = "172.16.3.9"
  }  
  
  nfsvm1 = {
    vmname = "tst-nfs-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapclusterhack/providers/Microsoft.Compute/images/TST-nfs-vm-1-image-20200324111354"
    vmpip = "172.16.3.11"
    vmsize = "Standard_D2s_v3"
  }  
 xscsvm0 = {
    vmname = "tst-xscs-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapclusterhack/providers/Microsoft.Compute/images/TST-xscs-vm-0-image-20200324111413"
    vmpip = "172.16.3.15"
    vmsize = "Standard_D2s_v3"
    lbpip = "172.16.3.6"
  }  
 xscsvm1 = {
    vmname = "tst-xscs-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapclusterhack/providers/Microsoft.Compute/images/TST-xscs-vm-1-image-20200324111431"
    vmpip = "172.16.3.14"
    vmsize = "Standard_D2s_v3"
    lbpip = "172.16.3.7"
  }  
 hanavm0 = {
    vmname = "tst-hana-vm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapclusterhack/providers/Microsoft.Compute/images/TST-hana-vm-0-image-20200324111256"
    vmpip = "172.16.3.10"
    vmsize = "Standard_E8s_v3"
    lbpip = "172.16.3.8"
  }

 hanavm1 = {
    vmname = "tst-hana-vm-1"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapclusterhack/providers/Microsoft.Compute/images/TST-hana-vm-1-image-20200324111315"
    vmpip = "172.16.3.13"
    vmsize = "Standard_E8s_v3"
  }    

 appvm = {
    vmname = "tst-app-avm-0"
    vmimage = "/subscriptions/afbba066-2190-4c21-b9ec-4a945b7bfbcc/resourceGroups/sapclusterhack/providers/Microsoft.Compute/images/TST-app-avm-0-image-20200324111233"
    vmpip = "172.16.3.5"
    vmsize = "Standard_D2s_v3"
  }  

}

