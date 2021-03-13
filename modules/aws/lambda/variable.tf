variable "convert_webp_lambda" {
  type = map(string)

  default = {
    "default.webp_images_bucket_name"      = "prod-webp-images"
    "stg.webp_images_bucket_name"          = "stg-webp-images"
    "dev.webp_images_bucket_name"          = "dev-webp-images"
    "qa.webp_images_bucket_name"           = "qa-webp-images"
    "default.webp_images_logs_bucket_name" = "prod-webp-images-logs"
    "stg.webp_images_logs_bucket_name"     = "stg-webp-images-logs"
    "dev.webp_images_logs_bucket_name"     = "dev-webp-images-logs"
    "qa.webp_images_logs_bucket_name"      = "qa-webp-images-logs"
  }
}

variable "main_domain_name" {
  type = string

  default = ""
}

variable "sub_domain_name" {
  type = map(string)

  default = {
    "default.webp_images" = "webp-images"
    "stg.webp_images"     = "stg-webp-images"
    "dev.webp_images"     = "dev-webp-images"
    "qa.webp_images"      = "qa-webp-images"
  }
}

variable "acm_us_east_1" {
  type = map(string)

  default = {}
}

data "aws_route53_zone" "main_host_zone" {
  name = var.main_domain_name
}
