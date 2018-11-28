data "aws_iam_policy_document" "ec2-elb-policy" {
  statement {
    actions   = [
      "ec2:Describe*",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:*",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "elasticloadbalancing:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "rancher" {
  description = "Allows Rancher instances to call EC2 services on your behalf"
  name   = "${var.cluster_name}RancherK8SEC2"
  policy = "${data.aws_iam_policy_document.ec2-elb-policy.json}"
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rancher" {
  name               = "${var.cluster_name}RancherK8SRole"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
  description        = "Allows Rancher instances to call EC2 services on your behalf"
}

resource "aws_iam_role_policy_attachment" "rancher-role-attach" {
  role       = "${aws_iam_role.rancher.name}"
  policy_arn = "${aws_iam_policy.rancher.arn}"
}

resource "aws_iam_instance_profile" "demo01" {
  name = "rancher_k8s_profile"
  role = "${aws_iam_role.rancher.name}"
}
