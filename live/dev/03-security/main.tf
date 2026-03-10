module "security" {
  source = "../../../modules/aws/security"

  infrastructure_name = data.terraform_remote_state.config.outputs.infrastructure_name
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  vpc_cidr            = data.terraform_remote_state.network.outputs.vpc_cidr 

  tags = {
    Project = "ocp-aws-non-integrated"
    Env     = "dev"
  }
}