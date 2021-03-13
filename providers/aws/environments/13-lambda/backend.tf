terraform {
  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "lambda/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"

  config = {
    bucket  = "keitakn-tfstate"
    key     = "env:/${terraform.workspace}/acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
