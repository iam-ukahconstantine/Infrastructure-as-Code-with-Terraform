variable "eip_domain" {}
variable "project_name" {}
variable "public_subnet_ids" {
    type = list(string)
}
variable "vpc_id" {}
variable "def_route" {}
variable "private_subnet_ids" {
    type = list(string)
}