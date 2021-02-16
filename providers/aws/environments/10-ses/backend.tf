terraform {
  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "ses/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
