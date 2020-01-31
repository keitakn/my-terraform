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
