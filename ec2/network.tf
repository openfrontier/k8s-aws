resource "aws_vpc" "demo01" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  tags {
    Name = "demo01"
    "kubernetes.io/cluster/aws.devops.demo" = "owned"
  }
}

resource "aws_security_group" "demo01" {
  name        = "ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = "${aws_vpc.demo01.id}"

  # terraform ssh provisioners
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.sg_inbound_ip_tf}"]
  }

  # ssh access from operators ip
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.sg_inbound_ip_ssh}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "demo01"
    "kubernetes.io/cluster/aws.devops.demo" = "owned"
  }
}

resource "aws_internet_gateway" "demo01" {
  vpc_id = "${aws_vpc.demo01.id}"

  tags {
    Name = "demo01"
    "kubernetes.io/cluster/aws.devops.demo" = "owned"
  }
}

resource "aws_default_route_table" "demo01" {
  default_route_table_id = "${aws_vpc.demo01.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo01.id}"
  }

  tags {
    Name = "demo01"
    "kubernetes.io/cluster/aws.devops.demo" = "owned"
  }
}

resource "aws_subnet" "demo01" {
  vpc_id                  = "${aws_vpc.demo01.id}"
  cidr_block              = "${aws_vpc.demo01.cidr_block}"
  map_public_ip_on_launch = true

  depends_on = ["aws_internet_gateway.demo01"]

  tags {
    Name = "demo01"
    "kubernetes.io/cluster/aws.devops.demo" = "owned"
  }
}

resource "aws_eip" "demo01" {
  count    = "${var.ec2-instance-count}"
  instance = "${element(aws_instance.demo01.*.id, count.index)}"
  vpc      = true

  depends_on = ["aws_internet_gateway.demo01"]

  tags {
    Name = "demo01-${count.index}"
    "kubernetes.io/cluster/aws.devops.demo" = "owned"
  }
}
