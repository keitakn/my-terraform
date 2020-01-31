resource "aws_ecr_repository" "go_rest_api" {
  name = "${terraform.workspace}-go-rest-api"
}

resource "aws_ecr_repository" "go_graphql" {
  name = "${terraform.workspace}-go-graphql"
}

resource "aws_ecr_repository" "golang_grpc_server" {
  name = "${terraform.workspace}-golang-grpc-server"
}

resource "aws_ecr_repository" "golang_grpc_client" {
  name = "${terraform.workspace}-golang-grpc-client"
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
  repository = aws_ecr_repository.go_rest_api.name
  policy     = local.lifecycle_policy
}

resource "aws_ecr_lifecycle_policy" "go_graphql" {
  repository = aws_ecr_repository.go_graphql.name
  policy     = local.lifecycle_policy
}

resource "aws_ecr_lifecycle_policy" "golang_grpc_server" {
  repository = aws_ecr_repository.golang_grpc_server.name
  policy     = local.lifecycle_policy
}

resource "aws_ecr_lifecycle_policy" "golang_grpc_client" {
  repository = aws_ecr_repository.golang_grpc_client.name
  policy     = local.lifecycle_policy
}
