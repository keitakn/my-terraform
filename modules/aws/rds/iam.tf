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

// RDS Proxy用のIAM
data "aws_iam_policy_document" "rds_proxy_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_proxy_role" {
  name               = "${terraform.workspace}-rds-proxy-role"
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_assume_role.json
}

resource "aws_iam_role_policy" "rds_proxy_policy" {
  name   = "${terraform.workspace}-rds-proxy-policy"
  role   = aws_iam_role.rds_proxy_role.id
  policy = file("../../../../modules/aws/rds/files/policy/rds-proxy-policy.json")
}

// RDS Migrationに利用するCodeBuildで利用するIAMロール
data "aws_iam_policy_document" "codebuild_trust_relationship" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
        "codedeploy.amazonaws.com",
        "secretsmanager.amazonaws.com",
        "s3.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "rds_migration_role" {
  name               = "${terraform.workspace}-rds-migration-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_relationship.json
}

resource "aws_iam_role_policy_attachment" "attachment_rds_migration_role" {
  role       = aws_iam_role.rds_migration_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
