variable "vmname" {
  description = "Name of the VM"
}
variable "vmtype" {
  description = "Type of the VM"

}
variable "location" {
  description = "Location for the VM"
}
variable "rgname" {
  description = "Resource group of the VM"

}
variable "vmext_depends_on" {
  type    = any
  default = null
}



