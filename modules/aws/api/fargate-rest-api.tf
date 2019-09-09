resource "aws_ecs_cluster" "go_rest_api_fargate_cluster" {
  name = lookup(
    var.go_rest_api,
    "${terraform.workspace}.name",
    var.go_rest_api["default.name"],
  )
}

data "template_file" "go_rest_api_fargate_template_file" {
  template = file("../../../../modules/aws/api/task/go-rest-api.json")

  vars = {
    image_url            = var.ecr["go_rest_api_image_url"]
    aws_region           = data.aws_region.current.name
    aws_logs_group       = aws_cloudwatch_log_group.go_rest_api.name
    slack_token_arn      = var.ssm["news_app_slack_token_arn"]
    sendgrid_api_key_arn = var.ssm["news_app_sendgrid_api_key_arn"]
  }
}

resource "aws_ecs_task_definition" "go_rest_api_fargate" {
  family = lookup(
    var.go_rest_api,
    "${terraform.workspace}.name",
    var.go_rest_api["default.name"],
  )
  network_mode             = "awsvpc"
  container_definitions    = data.template_file.go_rest_api_fargate_template_file.rendered
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  depends_on = [aws_cloudwatch_log_group.go_rest_api]
}

resource "aws_ecs_service" "go_rest_api_fargate_service" {
  name = lookup(
    var.go_rest_api,
    "${terraform.workspace}.name",
    var.go_rest_api["default.name"],
  )
  cluster         = aws_ecs_cluster.go_rest_api_fargate_cluster.id
  task_definition = aws_ecs_task_definition.go_rest_api_fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.go_rest_api_blue.id
    container_name   = "go"
    container_port   = 8080
  }

  network_configuration {
    subnets = [
      var.vpc["subnet_private_1"],
      var.vpc["subnet_private_2"],
      var.vpc["subnet_private_3"],
    ]

    security_groups = [
      aws_security_group.go_rest_api.id,
    ]
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer,
      desired_count,
    ]
  }

  depends_on = [aws_alb_listener.rest_api_alb]
}
