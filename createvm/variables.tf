variable "rgname" {
    description = "Name of the resource group to deploy the resources"
 }
variable "location" {
    description = "Specifies the location to deploy the resources"
    default = "WestEurope"
}
variable "vmname" {
  description = "Namw of the VM to be created"  
}

variable "adminuser" {
  description = "Username for logging in to the Virtual Machines"
  default = "azureuser"
}
variable "adminpassword" {
  description = "Password for logging in to the Virtual Machines"
}
variable "tags" {
  description = "A map of tags to the deployed resources. Empty by default."
  type        = "map"
  default     = {}
}
variable "image_id" {
    description = "Custom image id"
  }
variable "private_ip" {
  description = "Private IP address"
 }
variable "subnet_id" {
  description = "Subnet ID for creating the VM"
  
}
variable "lbid" {
    description = "Load balancer ID"
  
}
variable "vmtype" {
  description = "VM type to be deployed"
}
variable "vmsize" {
  description = "VM size to be deployed"
}
variable "vm_depends_on" {
  type = any
  default = null
}



