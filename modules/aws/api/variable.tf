variable "api" {
  type = "map"

  default = {
    default.name = "prod-api"
    stg.name     = "stg-api"
    dev.name     = "dev-api"
    qa.name      = "dev-api"
    region       = "ap-northeast-1"
  }
}

variable "go_rest_api" {
  type = "map"

  default = {
    default.name = "prod-go-rest-api"
    stg.name     = "stg-go-rest-api"
    dev.name     = "dev-go-rest-api"
    qa.name      = "dev-go-rest-api"
    region       = "ap-northeast-1"
  }
}

variable "go_graphql" {
  type = "map"

  default = {
    default.name = "prod-go-graphql"
    stg.name     = "stg-go-graphql"
    dev.name     = "dev-go-graphql"
    qa.name      = "dev-go-graphql"
    region       = "ap-northeast-1"
  }
}

variable "main_domain_name" {
  type = "string"

  default = "keitakn.de"
}

variable "sub_domain_name" {
  type = "map"

  default = {
    default.api_name = "api"
    stg.api_name     = "stg-api"
    dev.api_name     = "dev-api"
    qa.api_name      = "qa-api"
  }
}

variable "vpc" {
  type = "map"

  default = {}
}

variable "ecr" {
  type = "map"

  default = {}
}

data "aws_elb_service_account" "aws_elb_service_account" {}
