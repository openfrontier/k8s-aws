module "rancher_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "rancher-k8s"
  description = "Allow ssh inbound traffic"
  vpc_id      = "${module.vpc.default_vpc_id}"

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "${var.sg_inbound_ips}"
    },
    {
      rule        = "http-8080-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule = "all-all"
    },
  ]

  tags {
    Name = "${var.cluster_name}"
    "kubernetes.io/cluster/k8s" = "owned"
  }

}