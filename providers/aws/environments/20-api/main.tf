module "api" {
  source = "../../../../modules/aws/api"
  vpc    = data.terraform_remote_state.network.outputs.vpc
  ecr    = data.terraform_remote_state.ecr.outputs.ecr
  ssm    = data.terraform_remote_state.ssm.outputs.ssm
}
