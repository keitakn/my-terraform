terraform {
  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "eks/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket  = "keitakn-tfstate"
    key     = "env:/${terraform.workspace}/network/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    bucket  = "keitakn-tfstate"
    key     = "env:/${terraform.workspace}/ecr/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}

data "terraform_remote_state" "ssm" {
  backend = "s3"

  config = {
    bucket  = "keitakn-tfstate"
    key     = "env:/${terraform.workspace}/ssm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
