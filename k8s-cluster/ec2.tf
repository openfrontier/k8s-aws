data "aws_vpc" "demo01" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}"]
  }
}

data "aws_subnet" "demo01" {
  vpc_id = "${data.aws_vpc.demo01.id}"

  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}"]
  }
}

data "aws_security_group" "demo01" {
  vpc_id = "${data.aws_vpc.demo01.id}"

  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}"]
  }
}

data "template_cloudinit_config" "demo01" {
  count = "${var.ec2_instance_count}"

  part {
    content_type = "text/cloud-config"
    content      = "hostname: ${var.cluster_name}-node-${count.index}\nmanage_etc_hosts: true"
  }
}

resource "aws_instance" "k8s" {
  depends_on      = ["rancher_registration_token.plane"]
  count           = "${var.ec2_instance_count}"
  ami             = "${lookup(var.ami_ids, var.os_type)}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.ssh_key_name}"

  subnet_id              = "${data.aws_subnet.demo01.id}"
  vpc_security_group_ids = ["${data.aws_security_group.demo01.id}"]

  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
    delete_on_termination = true
  }

  user_data = "${data.template_cloudinit_config.demo01.*.rendered[count.index]}"

  tags {
    Name = "${var.cluster_name}-${count.index}"
    "kubernetes.io/cluster/k8s" = "owned"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "curl https://releases.rancher.com/install-docker/17.09.sh | sed s/17.09.0/17.09.1/g | sh",
      "sleep 10",
      "sudo usermod -aG docker ${lookup(var.ssh_users, var.os_type)}",
      "sleep 1",
      "${rancher_registration_token.plane.command}"
    ]
    on_failure = "fail"

    connection {
      type        = "ssh"
      user        = "${lookup(var.ssh_users, var.os_type)}"
      private_key = "${file("${var.ssh_key_path}")}"
      timeout     = "10m"
    }
  }
}

resource "aws_eip" "demo01" {
  count    = "${var.ec2_instance_count}"
  instance = "${element(aws_instance.k8s.*.id, count.index)}"
  vpc      = true

  tags {
    Name = "${var.cluster_name}-${count.index}"
    "kubernetes.io/cluster/k8s" = "owned"
  }
}

resource "aws_instance" "compute" {
  depends_on      = ["rancher_registration_token.compute"]
  count           = "${var.ec2_compute_count}"
  ami             = "${lookup(var.ami_ids, var.os_type)}"
  instance_type   = "${var.compute_instance_type}"
  key_name        = "${var.ssh_key_name}"

  subnet_id              = "${data.aws_subnet.demo01.id}"
  vpc_security_group_ids = ["${data.aws_security_group.demo01.id}"]

  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
    delete_on_termination = true
  }

  user_data = "${data.template_cloudinit_config.demo01.*.rendered[count.index]}"

  tags {
    Name = "${var.cluster_name}-compute-${count.index}"
    "kubernetes.io/cluster/k8s" = "owned"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "curl https://releases.rancher.com/install-docker/17.09.sh | sed s/17.09.0/17.09.1/g | sh",
      "sleep 10",
      "sudo usermod -aG docker ${lookup(var.ssh_users, var.os_type)}",
      "sleep 1",
      "${rancher_registration_token.compute.command}"
    ]
    on_failure = "fail"

    connection {
      type        = "ssh"
      user        = "${lookup(var.ssh_users, var.os_type)}"
      private_key = "${file("${var.ssh_key_path}")}"
      timeout     = "10m"
    }
  }
}

resource "aws_eip" "compute" {
  count    = "${var.ec2_compute_count}"
  instance = "${element(aws_instance.compute.*.id, count.index)}"
  vpc      = true

  tags {
    Name = "${var.cluster_name}-compute-${count.index}"
    "kubernetes.io/cluster/k8s" = "owned"
  }
}
