terraform {
  required_version = "=0.12.8"

  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "ssm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
