resource "aws_vpc" "vpc" {
  cidr_block           = "${lookup(var.vpc, "${terraform.env}.cidr", var.vpc["default.cidr"])}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${lookup(var.vpc, "${terraform.env}.name", var.vpc["default.name"])}"
  }
}

data "aws_iam_policy_document" "vpc_flow_log_trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vpc_flow_log_policy" {
  "statement" {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

data "aws_region" "current" {}

resource "aws_iam_role" "vpc_flow_log_role" {
  name               = "${terraform.workspace}-${data.aws_region.current.name}-vpc-flow-log-role"
  assume_role_policy = "${data.aws_iam_policy_document.vpc_flow_log_trust_relationship.json}"
}

resource "aws_iam_role_policy" "vpc_flow_logs_role" {
  role   = "${aws_iam_role.vpc_flow_log_role.name}"
  policy = "${data.aws_iam_policy_document.vpc_flow_log_policy.json}"
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "${terraform.workspace}-vpc-flow-log"
  retention_in_days = 1
}

resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = "${aws_iam_role.vpc_flow_log_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.vpc_flow_log.arn}"
  traffic_type    = "REJECT"
  vpc_id          = "${aws_vpc.vpc.id}"
}
