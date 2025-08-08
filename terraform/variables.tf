variable "ibm_api_key" {
  sensitive = true
}
variable "ibm_region" {
  default = "us-south"
}
variable "ssh_key_name" {
  default = "lab-key"
}