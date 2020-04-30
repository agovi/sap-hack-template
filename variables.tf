variable "rgname" {
  description = "Name of the resource group to deploy the resources"
  default     = "SAP-Open-hack"
}
variable "location" {
  description = "Specify Azure Region to deploy the resources (eg WestCentralUS EastUS2 CanadaCentral FranceCentral WestEurope NorthEurope)"
  //default     = "WestEurope"
}
variable "adminuser" {
  description = "Username for logging in to the Virtual Machines"
  default     = "azureuser"
}
variable "adminpassword" {
  description = "Password for logging in to the Windows jumpbox"
}


variable "sshkeypath" {
  description = "Path for the SSH keys to be used for passwordless login to Linux VMs (eg ~/.ssh/id_rsa.pub)"
  //default     = "~/.ssh/id_rsa.pub"
}
variable "tags" {
  description = "A map of tags to the deployed resources. Empty by default."
  type        = "map"
  default     = {}
}
variable "vnetprefix" {
  description = "Address prefix for the VNET"
  default     = ["172.16.3.0/24", "172.16.4.0/24"]
}
variable "sapsubnetprefix" {
  description = "Address prefix for subnet"
  default     = "172.16.3.0/24"
}
variable "hubsubnetprefix" {
  description = "Address prefix for Hub subnet"
  default     = "172.16.4.0/26"
}

variable "jb_config" {
  description = "Parameters requried to build Jumpbox VM"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "sbd_config" {
  description = "Parameters requried to build SBD VM"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "nfs_node0_config" {
  description = "Parameters requried to build NFS Node 0"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "nfs_node1_config" {
  description = "Parameters requried to build NFS Node 1"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "hana_node0_config" {
  description = "Parameters requried to build HANA Node 0"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "hana_node1_config" {
  description = "Parameters requried to build HANA Node 1"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "xscs_node0_config" {
  description = "Parameters requried to build ASCS/ERS Node 0"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "xscs_node1_config" {
  description = "Parameters requried to build ASCS/ERS Node 1"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "app_config" {
  description = "Parameters requried to build SAP App server"
  type        = "map"
  default = {
    vmname    = ""
    imageid   = ""
    privateip = ""
    vmsize    = ""

  }
}

variable "lb_config" {
  description = "Parameters requried for load balancers"
  type        = "map"
  default = {
    hanapip = ""
    nfspip  = ""
    xscspip = ""
  }
}

