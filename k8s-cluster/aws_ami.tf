data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]
}
data "aws_ami" "centos" {
  most_recent = true
  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
   owners = ["679593333241"]
}

locals {
  # constant lookup table for AMIs
  ostype_amis = {
    "centos" = "${data.aws_ami.centos.id}"
    "ubuntu" = "${data.aws_ami.ubuntu.id}"
  }
}