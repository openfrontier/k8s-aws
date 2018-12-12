module "rancher_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "rancher-k8s"
  description = "Allow ssh inbound traffic"
  vpc_id      = "${module.vpc.default_vpc_id}"

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "terraform ssh provisioners"
      cidr_blocks = "${var.sg_inbound_ips}"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "rancher port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http port"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "access from same vpc"
      self        = true
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "outbound internet access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags {
    Name = "${var.cluster_name}"
    "kubernetes.io/cluster/k8s" = "owned"
  }

}