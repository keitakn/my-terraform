resource "aws_cloudwatch_log_group" "go_rest_api" {
  name = lookup(
    var.go_rest_api,
    "${terraform.workspace}.name",
    var.go_rest_api["default.name"],
  )
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "go_graphql" {
  name = lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )
  retention_in_days = 30
}
