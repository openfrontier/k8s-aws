module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  enable_nat_gateway  = true
  single_nat_gateway  = false
  reuse_nat_ips       = true
  external_nat_ip_ids = ["${aws_eip.rancherserver.id}"]

  map_public_ip_on_launch = true

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
