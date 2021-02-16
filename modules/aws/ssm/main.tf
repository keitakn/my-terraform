// 既に存在するSeecretManagerリソースを参照する
// この場合AWSに {環境変数}/keitakn/slack という名前で登録されている前提
data "aws_secretsmanager_secret" "slack_secret" {
  name = "${terraform.workspace}/keitakn/slack"
}

data "aws_secretsmanager_secret_version" "slack_secret" {
  secret_id = data.aws_secretsmanager_secret.slack_secret.id
}

// 既に存在するSeecretManagerリソースを参照する
// この場合AWSに {環境変数}/keitakn/sendgrid という名前で登録されている前提
data "aws_secretsmanager_secret" "sendgrid_secret" {
  name = "${terraform.workspace}/keitakn/sendgrid"
}

data "aws_secretsmanager_secret_version" "sendgrid_secret" {
  secret_id = data.aws_secretsmanager_secret.sendgrid_secret.id
}

// デコードしたJSONを元にパラメータストアを作成する
resource "aws_ssm_parameter" "news_app_slack_token" {
  name  = "/${terraform.workspace}/test-app/news/slack-token"
  type  = "SecureString"
  value = jsondecode(data.aws_secretsmanager_secret_version.slack_secret.secret_string)["TOKEN"]
}

resource "aws_ssm_parameter" "news_app_sendgrid_api_key" {
  name  = "/${terraform.workspace}/test-app/news/sendgrid-api-key"
  type  = "SecureString"
  value = jsondecode(data.aws_secretsmanager_secret_version.sendgrid_secret.secret_string)["API_KEY"]
}

resource "aws_ssm_parameter" "weather_app_slack_token" {
  name  = "/${terraform.workspace}/test-app/weather/slack-token"
  type  = "SecureString"
  value = jsondecode(data.aws_secretsmanager_secret_version.slack_secret.secret_string)["TOKEN"]
}

resource "aws_ssm_parameter" "weather_app_sendgrid_api_key" {
  name  = "/${terraform.workspace}/test-app/weather/sendgrid-api-key"
  type  = "SecureString"
  value = jsondecode(data.aws_secretsmanager_secret_version.sendgrid_secret.secret_string)["API_KEY"]
}

// AWS.SSM. getParametersByPath のリミット件数をテストする為のresources
resource "aws_ssm_parameter" "sample_parameters" {
  count = 21
  name  = "/${terraform.workspace}/test-app/sample-list/KEY${count.index}"
  type  = "String"
  value = "TestValue${count.index}"
}
