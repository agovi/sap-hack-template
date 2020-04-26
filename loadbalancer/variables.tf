variable "vmtype" {
  description = "Type of the VM"

}
variable "location" {
  description = "Location for the VM"
}

variable "lbpip" {
  description = "Private IP for load balancer"
}

variable "rgname" {
  description = "Resource group of the VM"

}

variable "subnet" {
  description = "Subnet ID for the load balancer"

}