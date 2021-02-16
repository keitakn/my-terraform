terraform {
  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "network/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
