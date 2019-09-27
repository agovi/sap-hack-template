variable "rgname" {
    description = "Name of the resource group to deploy the resources"
 }
variable "location" {
    description = "Specifies the location to deploy the resources"
    default = "WestEurope"
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
variable "vnetprefix" {
    description = "Address prefix for the VNET"
    default = ["172.16.1.0/24"]
}
variable "subnetprefix" {
    description = "Address prefix for subnet"
    default  = "172.16.1.0/24"
}
