data "aws_iam_policy_document" "rds_monitoring_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_monitoring_role" {
  name               = "${terraform.workspace}-rds-monitoring"
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_policy.json
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

// ここから下は接続確認用のEC2の為のIAMロール
data "aws_iam_policy_document" "assume_bastion_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion_role" {
  name               = lookup(var.bastion, "${terraform.workspace}.name", var.bastion["default.name"])
  assume_role_policy = data.aws_iam_policy_document.assume_bastion_role.json
}

data "aws_iam_policy" "systems_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "bastion_role_attachment" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = data.aws_iam_policy.systems_manager.arn
}
