resource "aws_ssm_parameter" "serverless_node_api_db_user" {
  name      = "/${terraform.workspace}/aws-serverless-node-api-boilerplate/DB_USERNAME"
  type      = "SecureString"
  value     = aws_rds_cluster.rds_cluster.master_username
  overwrite = true
}

resource "aws_ssm_parameter" "serverless_node_api_db_password" {
  name      = "/${terraform.workspace}/aws-serverless-node-api-boilerplate/DB_PASSWORD"
  type      = "SecureString"
  value     = aws_rds_cluster.rds_cluster.master_password
  overwrite = true
}
