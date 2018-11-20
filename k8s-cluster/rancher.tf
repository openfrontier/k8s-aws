data "aws_instance" "rancherserver" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-rancher"]
  }
}
provider "rancher" {
  api_url = "http://${data.aws_instance.rancherserver.public_ip}:8080"
}

resource "rancher_environment" "demo01" {
  name = "k8s.demo"
  orchestration = "kubernetes"
}

resource "rancher_registration_token" "demo01" {
  name = "k8s_demo_token"
  environment_id = "${rancher_environment.demo01.id}"

  host_labels {
    orchestration = "true",
    etcd          = "true",
    compute       = "true"
    tier          = "ingress"
  }
}
