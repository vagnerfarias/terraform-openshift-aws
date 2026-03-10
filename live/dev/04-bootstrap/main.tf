module "bootstrap" {
  source = "../../../modules/aws/bootstrap"

  infrastructure_name    = data.terraform_remote_state.config.outputs.infrastructure_name
  rhcos_ami_id           = data.terraform_remote_state.config.outputs.rhcos_ami_id
  bootstrap_ignition_url = data.terraform_remote_state.config.outputs.bootstrap_ignition_url

  subnet_id = data.terraform_remote_state.network.outputs.private_subnet_ids[0]

  security_group_ids = [
    data.terraform_remote_state.security.outputs.master_security_group_id
  ]

  instance_profile_name = data.terraform_remote_state.security.outputs.master_instance_profile_name

  external_api_target_group_arn    = data.terraform_remote_state.edge.outputs.external_api_target_group_arn
  internal_api_target_group_arn    = data.terraform_remote_state.edge.outputs.internal_api_target_group_arn
  internal_service_target_group_arn = data.terraform_remote_state.edge.outputs.internal_service_target_group_arn

  tags = {
    Project = "ocp-aws-non-integrated"
    Env     = "dev"
  }
}