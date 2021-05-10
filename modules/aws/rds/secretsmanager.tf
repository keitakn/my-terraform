data "aws_secretsmanager_secret" "rds_secret" {
  name = "${terraform.workspace}/keitakn/rds"
}

data "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}
