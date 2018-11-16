output "agent_nodes_eips" {
  value = "${join(", ", aws_eip.demo01.*.public_ip)}"
}
output "rancher_agent_join_cmd" {
  value = "${rancher_registration_token.demo01.command}"
}
output "rancher_agent_join_url" {
  value = "${rancher_registration_token.demo01.registration_url}"
}
output "rancher_agent_join_token" {
  value = "${rancher_registration_token.demo01.token}"
}
