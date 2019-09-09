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
    "default.name"        = "prod-go-rest-api"
    "stg.name"            = "stg-go-rest-api"
    "dev.name"            = "dev-go-rest-api"
    "qa.name"             = "dev-go-rest-api"
    "region"              = "ap-northeast-1"
    "default.logs_bucket" = "prod-go-rest-api-alb-logs"
    "stg.logs_bucket"     = "stg-go-rest-api-alb-logs"
    "dev.logs_bucket"     = "dev-go-rest-api-alb-logs"
    "qa.logs_bucket"      = "qa-go-rest-api-alb-logs"
  }
}

variable "go_graphql" {
  type = map(string)

  default = {
    "default.name"        = "prod-go-graphql"
    "stg.name"            = "stg-go-graphql"
    "dev.name"            = "dev-go-graphql"
    "qa.name"             = "dev-go-graphql"
    "region"              = "ap-northeast-1"
    "default.logs_bucket" = "prod-go-graphql-alb-logs"
    "stg.logs_bucket"     = "stg-go-graphql-alb-logs"
    "dev.logs_bucket"     = "dev-go-graphql-alb-logs"
    "qa.logs_bucket"      = "qa-go-graphql-alb-logs"
  }
}

variable "main_domain_name" {
  type = string

  default = "keitakn.de"
}

variable "sub_domain_name" {
  type = map(string)

  default = {
    "default.rest_api" = "rest-api"
    "stg.rest_api"     = "stg-rest-api"
    "dev.rest_api"     = "dev-rest-api"
    "qa.rest_api"      = "qa-rest-api"
    "default.graphql"  = "graphql"
    "stg.graphql"      = "stg-graphql"
    "dev.graphql"      = "dev-graphql"
    "qa.graphql"       = "qa-graphql"
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

variable "ssm" {
  type = map(string)

  default = {}
}

data "aws_elb_service_account" "aws_elb_service_account" {
}

data "aws_region" "current" {
}
