module "cognito" {
  source = "../../../../modules/aws/cognito"
  ses    = data.terraform_remote_state.ses.outputs.ses
}
