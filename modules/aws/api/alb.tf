resource "aws_alb" "rest_api_alb" {
  name               = lookup(var.go_rest_api, "${terraform.workspace}.name", var.go_rest_api["default.name"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api_alb.id]

  subnets = [
    var.vpc["subnet_public_1"],
    var.vpc["subnet_public_2"],
    var.vpc["subnet_public_3"],
  ]

  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.rest_api_alb_logs.bucket
    prefix  = "raw"
  }

  tags = {
    Name = "${lookup(var.go_rest_api, "${terraform.workspace}.name", var.go_rest_api["default.name"])}-alb"
  }
}

resource "aws_alb_target_group" "go_rest_api_blue" {
  name = "${lookup(
    var.go_rest_api,
    "${terraform.workspace}.name",
    var.go_rest_api["default.name"],
  )}-blue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc["vpc_id"]

  health_check {
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    matcher             = 200
  }

  target_type = "ip"
}

resource "aws_alb_target_group" "go_rest_api_green" {
  name = "${lookup(
    var.go_rest_api,
    "${terraform.workspace}.name",
    var.go_rest_api["default.name"],
  )}-green"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc["vpc_id"]

  health_check {
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    matcher             = 200
  }

  target_type = "ip"
}

resource "aws_alb_listener" "rest_api_alb" {
  load_balancer_arn = aws_alb.rest_api_alb.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = data.aws_acm_certificate.main.arn

  lifecycle {
    ignore_changes = [default_action]
  }

  default_action {
    target_group_arn = aws_alb_target_group.go_rest_api_blue.id
    type             = "forward"
  }
}

resource "aws_alb" "graphql_alb" {
  name               = lookup(var.go_graphql, "${terraform.workspace}.name", var.go_graphql["default.name"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api_alb.id]

  subnets = [
    var.vpc["subnet_public_1"],
    var.vpc["subnet_public_2"],
    var.vpc["subnet_public_3"],
  ]

  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.graphql_alb_logs.bucket
    prefix  = "raw"
  }

  tags = {
    Name = "${lookup(var.go_graphql, "${terraform.workspace}.name", var.go_graphql["default.name"])}-alb"
  }
}

resource "aws_alb_target_group" "go_graphql_blue" {
  name = "${lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )}-blue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc["vpc_id"]

  health_check {
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    matcher             = 200
  }

  target_type = "ip"
}

resource "aws_alb_target_group" "go_graphql_green" {
  name = "${lookup(
    var.go_graphql,
    "${terraform.workspace}.name",
    var.go_graphql["default.name"],
  )}-green"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc["vpc_id"]

  health_check {
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    matcher             = 200
  }

  target_type = "ip"
}

resource "aws_alb_listener" "graphql_alb" {
  load_balancer_arn = aws_alb.graphql_alb.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = data.aws_acm_certificate.main.arn

  lifecycle {
    ignore_changes = [default_action]
  }

  default_action {
    target_group_arn = aws_alb_target_group.go_graphql_blue.id
    type             = "forward"
  }
}
