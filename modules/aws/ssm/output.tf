output "ssm" {
  value = "${
    map(
      "news_app_slack_token_id", "${aws_ssm_parameter.news_app_slack_token.id}",
      "news_app_sendgrid_api_key_id", "${aws_ssm_parameter.news_app_sendgrid_api_key.id}",
      "weather_app_slack_token_id", "${aws_ssm_parameter.weather_app_slack_token.id}",
      "weather_app_sendgrid_api_key_id", "${aws_ssm_parameter.weather_app_sendgrid_api_key.id}"
    )
  }"
}
