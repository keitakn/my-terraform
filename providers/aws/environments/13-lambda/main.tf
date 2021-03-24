module "lambda" {
  source           = "../../../../modules/aws/lambda"
  main_domain_name = var.main_domain_name
  acm_us_east_1    = data.terraform_remote_state.acm.outputs.acm_us_east_1
}
