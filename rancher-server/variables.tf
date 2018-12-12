variable "cluster_name" {
  default = "Demo"
}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "ap-northeast-2"
}
variable "ssh_users" {
  default = {
    "centos" = "centos"
    "ubuntu" = "ubuntu"
  }
}
variable "ssh_key_name" {}
variable "ssh_key_path" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "vpc_cidr_block" {}
variable "sg_inbound_ips" {}
variable "os_type" {}
variable "root_volume_type" {
  default = "gp2"
}
variable "root_volume_size" {
  default = "8"
}
variable "rancher_start_script" {
  default = "scripts/rancher.sh"
}
