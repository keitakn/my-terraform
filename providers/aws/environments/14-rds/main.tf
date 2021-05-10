module "api" {
  source = "../../../../modules/aws/rds"
  vpc    = data.terraform_remote_state.network.outputs.vpc
}
