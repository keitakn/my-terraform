terraform {
  required_version = "=0.11.13"

  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "api/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket  = "keitakn-tfstate"
    key     = "env:/${terraform.env}/network/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config {
    bucket  = "keitakn-tfstate"
    key     = "env:/${terraform.env}/ecr/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
