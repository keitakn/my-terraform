module "vpc" {
  source            = "../../../../modules/aws/vpc"
  availability_zone = var.default_az
}

// マルチリージョンは料金が高いので普段はコメントアウト、検証が必要な時だけコメントアウトを解除する
//module "vpc_us_east_1" {
//  source            = "../../../../modules/aws/vpc"
//  availability_zone = var.us_east_1_az
//
//  providers = {
//    aws = aws.us_east_1
//  }
//}
