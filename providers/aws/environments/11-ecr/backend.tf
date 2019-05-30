terraform {
  required_version = "=0.11.13"

  backend "s3" {
    bucket  = "keitakn-tfstate"
    key     = "ecr/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
