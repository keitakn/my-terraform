terraform {
  required_version = "=0.13.6"

  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "ssm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
