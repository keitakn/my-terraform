terraform {
  required_version = "=0.13.6"

  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "cognito/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}

data "terraform_remote_state" "ses" {
  backend = "s3"

  config = {
    bucket  = "keitakn-tfstate"
    key     = "env:/${terraform.workspace}/ses/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
