data "aws_iam_policy_document" "codedeploy_for_fargate_trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "codedeploy.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "codedeploy_for_fagate" {
  "statement" {
    effect = "Allow"

    actions = ["iam:PassRole"]

    resources = ["*"]
  }
}

resource "aws_iam_role" "codedeploy_for_fargate_role" {
  name               = "${terraform.workspace}-fargate-codedeploy-role"
  assume_role_policy = "${data.aws_iam_policy_document.codedeploy_for_fargate_trust_relationship.json}"
}

resource "aws_iam_role_policy" "codedeploy_for_fargate" {
  name   = "${terraform.workspace}-fargate-codedeploy"
  role   = "${aws_iam_role.codedeploy_for_fargate_role.id}"
  policy = "${data.aws_iam_policy_document.codedeploy_for_fagate.json}"
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_attach" {
  role       = "${aws_iam_role.codedeploy_for_fargate_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_ecs_attach" {
  role       = "${aws_iam_role.codedeploy_for_fargate_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECSLimited"
}

resource "aws_codedeploy_app" "go_rest_api" {
  compute_platform = "ECS"
  name             = "${lookup(var.go_rest_api, "${terraform.env}.name", var.go_rest_api["default.name"])}"
}

resource "aws_codedeploy_deployment_group" "fargate_api_blue_green_deploy" {
  app_name               = "${aws_codedeploy_app.go_rest_api.name}"
  deployment_group_name  = "blue-green"
  service_role_arn       = "${aws_iam_role.codedeploy_for_fargate_role.arn}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = "1"
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = "${aws_ecs_cluster.go_rest_api_fargate_cluster.name}"
    service_name = "${aws_ecs_service.go_rest_api_fargate_service.name}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${aws_alb_listener.api_alb.arn}"]
      }

      target_group {
        name = "${aws_alb_target_group.go_rest_api_blue.name}"
      }

      target_group {
        name = "${aws_alb_target_group.go_rest_api_green.name}"
      }
    }
  }
}

resource "aws_codedeploy_app" "go_graphql" {
  compute_platform = "ECS"
  name             = "${lookup(var.go_graphql, "${terraform.env}.name", var.go_graphql["default.name"])}"
}

resource "aws_codedeploy_deployment_group" "go_graphql_blue_green_deploy" {
  app_name               = "${aws_codedeploy_app.go_graphql.name}"
  deployment_group_name  = "blue-green"
  service_role_arn       = "${aws_iam_role.codedeploy_for_fargate_role.arn}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = "1"
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = "${aws_ecs_cluster.go_graphql_fargate_cluster.name}"
    service_name = "${aws_ecs_service.go_graphql_fargate_service.name}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${aws_alb_listener.api_alb.arn}"]
      }

      target_group {
        name = "${aws_alb_target_group.go_graphql_blue.name}"
      }

      target_group {
        name = "${aws_alb_target_group.go_graphql_green.name}"
      }
    }
  }
}
