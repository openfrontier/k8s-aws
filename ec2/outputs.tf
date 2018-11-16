output "rancher_server_ip" {
  value = "${aws_eip.rancherserver.public_ip}"
}
output "computing_nodes_eips" {
  value = "${join(", ", aws_eip.demo01.*.public_ip)}"
}
