output "ssm" {
  value = {
    "news_app_slack_token_arn"         = aws_ssm_parameter.news_app_slack_token.arn
    "news_app_sendgrid_api_key_arn"    = aws_ssm_parameter.news_app_sendgrid_api_key.arn
    "weather_app_slack_token_arn"      = aws_ssm_parameter.weather_app_slack_token.arn
    "weather_app_sendgrid_api_key_arn" = aws_ssm_parameter.weather_app_sendgrid_api_key.arn
  }
}
