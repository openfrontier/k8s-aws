resource "aws_vpc" "demo01" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.cluster_name}"
    "kubernetes.io/cluster/k8s" = "owned"
  }
}

resource "aws_internet_gateway" "demo01" {
  vpc_id = "${aws_vpc.demo01.id}"

  tags {
    Name = "${var.cluster_name}"
    "kubernetes.io/cluster/k8s" = "owned"
  }
}

resource "aws_default_route_table" "demo01" {
  default_route_table_id = "${aws_vpc.demo01.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo01.id}"
  }

  tags {
    Name = "${var.cluster_name}"
    "kubernetes.io/cluster/k8s" = "owned"
  }
}

resource "aws_subnet" "demo01" {
  vpc_id                  = "${aws_vpc.demo01.id}"
  cidr_block              = "${aws_vpc.demo01.cidr_block}"
  map_public_ip_on_launch = true

  depends_on = ["aws_internet_gateway.demo01"]

  tags {
    Name = "${var.cluster_name}"
    "kubernetes.io/cluster/k8s" = "owned"
  }
}

resource "aws_eip" "rancherserver" {
  instance = "${aws_instance.rancherserver.id}"
  vpc      = true

  tags {
    Name = "${var.cluster_name}-rancher"
    "kubernetes.io/cluster/k8s" = "owned"
  }
}
