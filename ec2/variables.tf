variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "ap-northeast-2"
}
variable "ami_ids" {
  default = {
    "centos" = "ami-bf9c36d1"
    "ubuntu" = "ami-013dda6d4ad165475"
  }
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
variable "sg_inbound_ip_ssh" {}
variable "sg_inbound_ip_tf" {}
variable "ec2_instance_count" {
  default = 3
}
variable "os_type" {}
variable "root_volume_type" {
  default = "gp2"
}
variable "root_volume_size" {
  default = "8"
}
