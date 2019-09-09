variable "vpc" {
  type = map(string)

  default = {
    "default.name"      = "prod-vpc"
    "stg.name"          = "stg-vpc"
    "dev.name"          = "dev-vpc"
    "default.cidr"      = "10.0.0.0/16"
    "stg.cidr"          = "10.1.0.0/16"
    "dev.cidr"          = "10.2.0.0/16"
    "qa.cidr"           = "10.3.0.0/16"
    "default.public_1"  = "10.0.0.0/24"
    "default.public_2"  = "10.0.1.0/24"
    "default.public_3"  = "10.0.2.0/24"
    "stg.public_1"      = "10.1.0.0/24"
    "stg.public_2"      = "10.1.1.0/24"
    "stg.public_3"      = "10.1.2.0/24"
    "dev.public_1"      = "10.2.0.0/24"
    "dev.public_2"      = "10.2.1.0/24"
    "dev.public_3"      = "10.2.2.0/24"
    "qa.public_1"       = "10.3.0.0/24"
    "qa.public_2"       = "10.3.1.0/24"
    "qa.public_3"       = "10.3.2.0/24"
    "default.private_1" = "10.0.10.0/24"
    "default.private_2" = "10.0.11.0/24"
    "default.private_3" = "10.0.12.0/24"
    "stg.private_1"     = "10.1.10.0/24"
    "stg.private_2"     = "10.1.11.0/24"
    "stg.private_3"     = "10.1.12.0/24"
    "dev.private_1"     = "10.2.10.0/24"
    "dev.private_2"     = "10.2.11.0/24"
    "dev.private_3"     = "10.2.12.0/24"
    "qa.private_1"      = "10.3.10.0/24"
    "qa.private_2"      = "10.3.11.0/24"
    "qa.private_3"      = "10.3.12.0/24"
  }
}

variable "availability_zone" {
  type    = map(string)
  default = {}
}
