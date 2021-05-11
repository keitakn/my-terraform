data "aws_secretsmanager_secret" "rds_secret" {
  name = "${terraform.workspace}/keitakn/rds"
}

data "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

// RDS Proxyから利用する接続情報
resource "aws_secretsmanager_secret" "rds_connection_info" {
  name = "${terraform.workspace}/keitakn/rds-connection-info"
}

resource "aws_secretsmanager_secret_version" "rds_connection_info" {
  secret_id = aws_secretsmanager_secret.rds_connection_info.id

  secret_string = jsonencode({
    username : aws_rds_cluster.rds_cluster.master_username
    password : aws_rds_cluster.rds_cluster.master_password
    engine : "mysql"
    host : aws_rds_cluster.rds_cluster.endpoint
    port : aws_rds_cluster.rds_cluster.port
    dbClusterIdentifier : aws_rds_cluster.rds_cluster.id
  })
}
