output "ecr" {
  value = {
    "go_rest_api_image_url" = aws_ecr_repository.go_rest_api.repository_url
    "go_graphql_image_url"  = aws_ecr_repository.go_graphql.repository_url
  }
}
