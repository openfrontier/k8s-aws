variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "ap-northeast-2"
}
variable "ami_id" {}
variable "ssh_user" {}
variable "ssh_key_name" {}
variable "ssh_key_path" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "vpc_cidr_block" {}
variable "sg_inbound_ip_ssh" {}
variable "sg_inbound_ip_tf" {}