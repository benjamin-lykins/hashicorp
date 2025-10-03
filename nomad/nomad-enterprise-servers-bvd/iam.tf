# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "nomad_discovery" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.nomad_discovery.json
  ]
}

resource "aws_iam_role_policy" "nomad_ec2" {
  name   = "${var.friendly_name_prefix}-nomad-controller-instance-role-policy-${var.aws_region}"
  role   = aws_iam_role.nomad_ec2.id
  policy = data.aws_iam_policy_document.combined.json
}

resource "aws_iam_role" "nomad_ec2" {
  name = "${var.friendly_name_prefix}-nomad-instance-role-${var.aws_region}"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(
    { "Name" = "${var.friendly_name_prefix}-nomad-instance-role-${var.aws_region}" },
    var.common_tags
  )
}

resource "aws_iam_instance_profile" "nomad_ec2" {
  name = "${var.friendly_name_prefix}-nomad-${var.aws_region}"
  path = "/"
  role = aws_iam_role.nomad_ec2.name
}

resource "aws_iam_role_policy_attachment" "aws_ssm" {
  count = var.ec2_allow_ssm == true ? 1 : 0

  role       = aws_iam_role.nomad_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
