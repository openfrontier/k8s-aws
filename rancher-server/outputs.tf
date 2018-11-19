output "rancher_server_url" {
  value = "http://${aws_eip.rancherserver.public_ip}:8080"
}
