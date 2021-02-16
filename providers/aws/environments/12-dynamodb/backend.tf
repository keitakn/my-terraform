terraform {
  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "dynamodb/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
