resource "aws_instance" "rancherserver" {
  ami             = "${lookup(var.ami_ids, var.os_type)}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.ssh_key_name}"

  subnet_id              = "${aws_subnet.demo01.id}"
  vpc_security_group_ids = ["${aws_security_group.demo01.id}"]

  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
    delete_on_termination = true
  }

  tags {
    Name = "${var.cluster_name}-rancher"
    "kubernetes.io/cluster/k8s" = "owned"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "curl -s https://releases.rancher.com/install-docker/17.09.sh | sed s/17.09.0/17.09.1/g | sh",
      "sleep 10",
      "sudo usermod -aG docker ${lookup(var.ssh_users, var.os_type)}",
      "sleep 1"
    ]
    on_failure = "fail"

    connection {
      type        = "ssh"
      user        = "${lookup(var.ssh_users, var.os_type)}"
      private_key = "${file("${var.ssh_key_path}")}"
      timeout     = "10m"
    }
  }

  provisioner "remote-exec" {
    script = "${var.rancher_start_script}"

    on_failure = "fail"

    connection {
      type        = "ssh"
      user        = "${lookup(var.ssh_users, var.os_type)}"
      private_key = "${file("${var.ssh_key_path}")}"
      timeout     = "10m"
    }
  }
}
