resource "aws_security_group" "serverless_node_api_migration" {
  name        = "${terraform.workspace}-serverless-node-api-migration"
  description = "aws-serverless-node-api-boilerplate execute RDS Migration"
  vpc_id      = var.vpc["vpc_id"]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_codebuild_project" "serverless_node_api_migration" {
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "DB_USERNAME"
      value = aws_ssm_parameter.serverless_node_api_db_user.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DB_PASSWORD"
      value = aws_ssm_parameter.serverless_node_api_db_password.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DB_HOST"
      value = "${aws_route53_record.rds_local_writer_domain_record.name}.${aws_route53_zone.rds_local_domain_name.name}"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "DB_NAME"
      value = "serverless_db"
      type  = "PLAINTEXT"
    }
  }

  name         = "${terraform.workspace}-serverless-node-api-rds-migration"
  service_role = aws_iam_role.rds_migration_role.arn

  source {
    type            = "GITHUB"
    location        = "https://github.com/nekochans/aws-serverless-node-api-boilerplate.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  vpc_config {
    security_group_ids = [aws_security_group.serverless_node_api_migration.id]

    subnets = [
      var.vpc["subnet_private_1"],
      var.vpc["subnet_private_2"],
      var.vpc["subnet_private_3"],
    ]

    vpc_id = var.vpc["vpc_id"]
  }
}
