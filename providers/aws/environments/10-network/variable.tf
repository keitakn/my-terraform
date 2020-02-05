variable "default_az" {
  type = map(string)

  default = {
    "default.az_1" = "ap-northeast-1a"
    "default.az_2" = "ap-northeast-1c"
    "default.az_3" = "ap-northeast-1d"
  }
}

//variable "us_east_1_az" {
//  type = map(string)
//
//  default = {
//    "default.az_1" = "us-east-1a"
//    "default.az_2" = "us-east-1b"
//    "default.az_3" = "us-east-1b"
//  }
//}
