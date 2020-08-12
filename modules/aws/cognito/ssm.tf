data "aws_secretsmanager_secret" "next_idaas" {
  name = "${terraform.workspace}/next-idaas"
}

data "aws_secretsmanager_secret_version" "next_idaas" {
  secret_id = data.aws_secretsmanager_secret.next_idaas.id
}
