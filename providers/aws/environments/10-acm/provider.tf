provider "aws" {
  region  = "ap-northeast-1"
  profile = "nekochans-dev"
}

provider "aws" {
  region  = "us-east-1"
  profile = "nekochans-dev"
  alias   = "us_east_1"
}
