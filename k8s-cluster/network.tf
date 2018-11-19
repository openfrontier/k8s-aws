resource "aws_eip" "demo01" {
  count    = "${var.ec2_instance_count}"
  instance = "${element(aws_instance.demo01.*.id, count.index)}"
  vpc      = true

  tags {
    Name = "${var.cluster_name}-${count.index}"
    "kubernetes.io/cluster/aws.devops.demo" = "owned"
  }
}
