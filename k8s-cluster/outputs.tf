output "agent_nodes_eips" {
  value = "${join(", ", aws_eip.demo01.*.public_ip)}"
}
output "rancher_plane_join_cmd" {
  value = "${rancher_registration_token.plane.command}"
}
output "rancher_compute_join_cmd" {
  value = "${rancher_registration_token.compute.command}"
}
output "rancher_plane_join_token" {
  value = "${rancher_registration_token.plane.token}"
}
output "rancher_compute_join_token" {
  value = "${rancher_registration_token.compute.token}"
}
