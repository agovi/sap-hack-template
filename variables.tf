variable "rgname" {
    description = "Name of the resource group to deploy the resources"
    default = "sap-openhack"
 }
variable "location" {
    description = "Specifies the location to deploy the resources"
    default = "WestEurope"
}
variable "adminuser" {
  description = "Username for logging in to the Virtual Machines"
  default = "azureuser"
}
/*variable "adminpassword" {
  description = "Password for logging in to the Virtual Machines"
}
*/

variable "sshkeypath" {
  description = "Path for the SSH keys to be used"
 default = "~/.ssh/id_rsa.pub"
}
variable "tags" {
  description = "A map of tags to the deployed resources. Empty by default."
  type        = "map"
  default     = {}
}
variable "vnetprefix" {
    description = "Address prefix for the VNET"
    default = ["172.16.3.0/24"]
}
variable "subnetprefix" {
    description = "Address prefix for subnet"
    default  = "172.16.3.0/24"
}
variable "image_id" {
  description = "Image id to be used for VM creation"
  default = ""
}


