terraform {
  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "rds/terraform.tfstate"
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
