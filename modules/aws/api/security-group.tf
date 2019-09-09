resource "aws_security_group" "api_alb" {
  name        = "${lookup(var.api, "${terraform.workspace}.name", var.api["default.name"])}-alb"
  description = "Security Group to ${lookup(var.api, "${terraform.workspace}.name", var.api["default.name"])}-alb"
  vpc_id      = var.vpc["vpc_id"]

  tags = {
    Name = "${lookup(var.api, "${terraform.workspace}.name", var.api["default.name"])}-alb"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "http_from_all_to_alb" {
  security_group_id = aws_security_group.api_alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_from_all_to_alb" {
  security_group_id = aws_security_group.api_alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "go_rest_api" {
  name = lookup(
    var.go_rest_api,
    "${terraform.workspace}.name",
    var.go_rest_api["default.name"],
  )
  description = "Security Group to ${lookup(
    var.go_rest_api,
    "${terraform.workspace}.name",
    var.go_rest_api["default.name"],
  )}"
  vpc_id = var.vpc["vpc_id"]

  tags = {
    Name = lookup(
      var.go_rest_api,
      "${terraform.workspace}.name",
      var.go_rest_api["default.name"],
    )
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "go_rest_api_from_alb" {
  security_group_id        = aws_security_group.go_rest_api.id
  type                     = "ingress"
  from_port                = "8080"
  to_port                  = "8080"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.api_alb.id
}

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
