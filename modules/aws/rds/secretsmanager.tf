data "aws_secretsmanager_secret" "rds_secret" {
  name = "${terraform.workspace}/keitakn/rds"
}

data "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

// RDS Proxyから利用する接続情報
// AWS Secrets Managerは一度削除すると7日間は同じ名前を再定義出来ない、対処法は下記を参照
// https://aws.amazon.com/jp/premiumsupport/knowledge-center/delete-secrets-manager-secret/
resource "aws_secretsmanager_secret" "rds_connection" {
  name = "${terraform.workspace}/keitakn/rds-connection"
}

resource "aws_secretsmanager_secret_version" "rds_connection" {
  secret_id = aws_secretsmanager_secret.rds_connection.id

  secret_string = jsonencode({
    username : aws_rds_cluster.rds_cluster.master_username
    password : aws_rds_cluster.rds_cluster.master_password
    engine : "mysql"
    host : aws_rds_cluster.rds_cluster.endpoint
    port : aws_rds_cluster.rds_cluster.port
    dbClusterIdentifier : aws_rds_cluster.rds_cluster.id
  })
}
