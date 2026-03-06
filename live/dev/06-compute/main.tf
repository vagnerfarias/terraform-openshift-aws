module "compute" {
  source = "../../../modules/compute"

  infrastructure_name = data.terraform_remote_state.config.outputs.infrastructure_name
  rhcos_ami_id        = data.terraform_remote_state.config.outputs.rhcos_ami_id
  worker_ignition_url = data.terraform_remote_state.config.outputs.worker_ignition_url

  subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  security_group_ids = [
    data.terraform_remote_state.security.outputs.worker_security_group_id
  ]

  instance_profile_name = data.terraform_remote_state.security.outputs.worker_instance_profile_name

  apps_http_target_group_arn  = data.terraform_remote_state.edge.outputs.apps_http_target_group_arn
  apps_https_target_group_arn = data.terraform_remote_state.edge.outputs.apps_https_target_group_arn

  instance_count = 2
  instance_type  = "m6i.xlarge"

  tags = {
    Project = "ocp-aws-non-integrated"
    Env     = "dev"
  }
}