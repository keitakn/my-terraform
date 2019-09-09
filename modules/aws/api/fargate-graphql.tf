resource "aws_security_group" "go_graphql" {
  name = lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )
  description = "Security Group to ${lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )}"
  vpc_id = var.vpc["vpc_id"]

  tags = {
    Name = lookup(
      var.go_graphql,
      "${terraform.workspace}.name",
      var.go_graphql["default.name"],
    )
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "go_graphql_from_alb" {
  security_group_id        = aws_security_group.go_graphql.id
  type                     = "ingress"
  from_port                = "8080"
  to_port                  = "8080"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.api_alb.id
}

resource "aws_cloudwatch_log_group" "go_graphql" {
  name = lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )
  retention_in_days = 30
}

resource "aws_ecs_cluster" "go_graphql_fargate_cluster" {
  name = lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )
}

data "template_file" "go_graphql_fargate_template_file" {
  template = file("../../../../modules/aws/api/task/go-graphql.json")

  vars = {
    image_url      = var.ecr["go_graphql_image_url"]
    aws_region     = data.aws_region.current.name
    aws_logs_group = aws_cloudwatch_log_group.go_graphql.name
  }
}

resource "aws_ecs_task_definition" "go_graphql_fargate" {
  family = lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )
  network_mode             = "awsvpc"
  container_definitions    = data.template_file.go_graphql_fargate_template_file.rendered
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  depends_on = [aws_cloudwatch_log_group.go_graphql]
}

resource "aws_ecs_service" "go_graphql_fargate_service" {
  name = lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )
  cluster         = aws_ecs_cluster.go_graphql_fargate_cluster.id
  task_definition = aws_ecs_task_definition.go_graphql_fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.go_graphql_blue.id
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
      aws_security_group.go_graphql.id,
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

  depends_on = [aws_alb_listener.api_alb]
}
