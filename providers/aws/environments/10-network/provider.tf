provider "aws" {
  region  = "ap-northeast-1"
  profile = "nekochans-dev"
}

// マルチリージョンは料金が高いので普段はコメントアウト、検証が必要な時だけコメントアウトを解除する
//provider "aws" {
//  region  = "us-east-1"
//  profile = "nekochans-dev"
//  alias   = "us_east_1"
//}
