// 接続確認用のLambda関数
resource "aws_security_group" "vpc_lambda" {
  name        = "${terraform.workspace}-vpc-lambda"
  description = "vpc lambda security group"
  vpc_id      = var.vpc["vpc_id"]

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_proxy" {
  name        = "${terraform.workspace}-rds-proxy"
  description = "rds proxy security group"
  vpc_id      = var.vpc["vpc_id"]

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_lambda.id, aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_proxy" "rds_proxy" {
  name                   = "${terraform.workspace}-rds-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = false
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.rds_proxy.id]
  vpc_subnet_ids = [
    var.vpc["subnet_private_1"],
    var.vpc["subnet_private_2"],
    var.vpc["subnet_private_3"],
  ]

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.rds_connection_info.arn
  }

  depends_on = [aws_rds_cluster.rds_cluster, aws_secretsmanager_secret_version.rds_connection_info]
}

resource "aws_db_proxy_default_target_group" "rds_proxy" {
  db_proxy_name = aws_db_proxy.rds_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "rds_proxy" {
  db_cluster_identifier = aws_rds_cluster.rds_cluster.id
  db_proxy_name         = aws_db_proxy.rds_proxy.name
  target_group_name     = aws_db_proxy_default_target_group.rds_proxy.name
}

resource "aws_db_proxy_endpoint" "read_only" {
  db_proxy_name          = aws_db_proxy.rds_proxy.name
  db_proxy_endpoint_name = "${terraform.workspace}-read-only"
  vpc_subnet_ids = [
    var.vpc["subnet_private_1"],
    var.vpc["subnet_private_2"],
    var.vpc["subnet_private_3"],
  ]
  target_role = "READ_ONLY"

  depends_on = [aws_db_proxy.rds_proxy]
}
