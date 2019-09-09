variable "api" {
  type = map(string)

  default = {
    "default.name" = "prod-api"
    "stg.name"     = "stg-api"
    "dev.name"     = "dev-api"
    "qa.name"      = "dev-api"
    "region"       = "ap-northeast-1"
  }
}

variable "go_rest_api" {
  type = map(string)

  default = {
    "default.name" = "prod-go-rest-api"
    "stg.name"     = "stg-go-rest-api"
    "dev.name"     = "dev-go-rest-api"
    "qa.name"      = "dev-go-rest-api"
    "region"       = "ap-northeast-1"
  }
}

variable "go_graphql" {
  type = map(string)

  default = {
    "default.name" = "prod-go-graphql"
    "stg.name"     = "stg-go-graphql"
    "dev.name"     = "dev-go-graphql"
    "qa.name"      = "dev-go-graphql"
    "region"       = "ap-northeast-1"
  }
}

variable "serverless_express" {
  type = map(string)

  default = {
    "default.name"     = "prod-serverless-express"
    "stg.name"         = "stg-serverless-express"
    "dev.name"         = "dev-serverless-express"
    "qa.name"          = "dev-serverless-express"
    "default.function" = "serverless-express-prod-server"
    "prod.function"    = "serverless-express-prod-server"
    "stg.function"     = "serverless-express-stg-server"
    "dev.function"     = "serverless-express-dev-server"
    "qa.function"      = "serverless-express-qa-server"
    "region"           = "ap-northeast-1"
  }
}

variable "main_domain_name" {
  type = string

  default = "keitakn.de"
}

variable "sub_domain_name" {
  type = map(string)

  default = {
    "default.api_name" = "api"
    "stg.api_name"     = "stg-api"
    "dev.api_name"     = "dev-api"
    "qa.api_name"      = "qa-api"
  }
}

variable "vpc" {
  type = map(string)

  default = {}
}

variable "ecr" {
  type = map(string)

  default = {}
}

data "aws_elb_service_account" "aws_elb_service_account" {
}

data "aws_caller_identity" "self" {
}
