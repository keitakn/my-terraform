terraform {
  required_version = "=0.13.6"

  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "ses/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
