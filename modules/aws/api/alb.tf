resource "aws_security_group" "api_alb" {
  name        = "${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}-alb"
  description = "Security Group to ${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}-alb"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}-alb"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "http_from_all_to_alb" {
  security_group_id = "${aws_security_group.api_alb.id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_from_all_to_alb" {
  security_group_id = "${aws_security_group.api_alb.id}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_s3_bucket" "api_alb_logs" {
  bucket        = "${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}-alb-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "put_api_alb_logs_policy" {
  "statement" {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.api_alb_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.aws_elb_service_account.id}"]
    }
  }
}

resource "aws_s3_bucket_policy" "api" {
  bucket = "${aws_s3_bucket.api_alb_logs.id}"
  policy = "${data.aws_iam_policy_document.put_api_alb_logs_policy.json}"
}

resource "aws_alb" "api_alb" {
  name               = "${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.api_alb.id}"]

  subnets = [
    "${var.vpc["subnet_public_1"]}",
    "${var.vpc["subnet_public_2"]}",
    "${var.vpc["subnet_public_3"]}",
  ]

  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket  = "${aws_s3_bucket.api_alb_logs.bucket}"
  }

  tags {
    Name = "${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}-alb"
  }
}

resource "aws_alb_target_group" "go_rest_api_blue" {
  name     = "${lookup(var.go_rest_api, "${terraform.env}.name", var.go_rest_api["default.name"])}-blue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${lookup(var.vpc, "vpc_id")}"

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
  name     = "${lookup(var.go_rest_api, "${terraform.env}.name", var.go_rest_api["default.name"])}-green"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${lookup(var.vpc, "vpc_id")}"

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

resource "aws_alb_target_group" "go_graphql_blue" {
  name     = "${lookup(var.go_graphql, "${terraform.env}.name", var.go_graphql["default.name"])}-blue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${lookup(var.vpc, "vpc_id")}"

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
  name     = "${lookup(var.go_graphql, "${terraform.env}.name", var.go_graphql["default.name"])}-green"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${lookup(var.vpc, "vpc_id")}"

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

resource "aws_alb_listener" "api_alb" {
  load_balancer_arn = "${aws_alb.api_alb.id}"
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = "${data.aws_acm_certificate.main.arn}"

  lifecycle {
    ignore_changes = ["default_action"]
  }

  default_action {
    target_group_arn = "${aws_alb_target_group.go_rest_api_blue.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "go_graphql" {
  listener_arn = "${aws_alb_listener.api_alb.arn}"

  lifecycle {
    ignore_changes = ["action"]
  }

  "action" {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.go_graphql_blue.id}"
  }

  "condition" {
    field  = "path-pattern"
    values = ["/graphql"]
  }
}
