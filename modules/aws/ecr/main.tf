resource "aws_ecr_repository" "go_rest_api" {
  name = "${terraform.workspace}-go-rest-api"
}

resource "aws_ecr_repository" "go_graphql" {
  name = "${terraform.workspace}-go-graphql"
}

locals {
  lifecycle_policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 10,
        "description": "Expire images count more than 5",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 5
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}

resource "aws_ecr_lifecycle_policy" "go_rest_api" {
  repository = "${aws_ecr_repository.go_rest_api.name}"
  policy     = "${local.lifecycle_policy}"
}

resource "aws_ecr_lifecycle_policy" "go_graphql" {
  repository = "${aws_ecr_repository.go_graphql.name}"
  policy     = "${local.lifecycle_policy}"
}
