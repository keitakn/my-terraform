output "vpc" {
  value = module.vpc.vpc
}

// マルチリージョンは料金が高いので普段はコメントアウト、検証が必要な時だけコメントアウトを解除する
//output "vpc_us_east_1" {
//  value = module.vpc_us_east_1.vpc
//}
