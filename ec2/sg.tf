resource "aws_security_group" "demo01" {
  name        = "rancher-k8s"
  description = "Allow ssh inbound traffic"
  vpc_id      = "${aws_vpc.demo01.id}"

  # terraform ssh provisioners
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.sg_inbound_ip_tf}", "${var.sg_inbound_ip_ssh}"]
  }

  # rancher port
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # kubernetes port
  ingress {
    from_port   = "10250"
    to_port     = "10255"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ipsec ports
  ingress {
    from_port   = "500"
    to_port     = "500"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "4500"
    to_port     = "4500"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # access from same vpc
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = "true"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.cluster_name}"
    "kubernetes.io/cluster/aws.devops.demo" = "owned"
  }
}
