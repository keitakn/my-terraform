module "ap_northeast_1_acm" {
  source           = "../../../../modules/aws/acm"
  main_domain_name = var.main_domain_name
}

module "us_east_1_acm" {
  source           = "../../../../modules/aws/acm"
  main_domain_name = var.main_domain_name


  providers = {
    aws = aws.us_east_1
  }
}
