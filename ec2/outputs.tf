output "elastic ip" {
  value = "${join(", ", aws_eip.demo01.*.public_ip)}"
}
