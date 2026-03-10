module "edge" {
  source = "../../../../modules/aws/edge"

  cluster_name          = data.terraform_remote_state.config.outputs.cluster_name
  base_domain           = data.terraform_remote_state.config.outputs.base_domain
  public_dns_zone_id    = data.terraform_remote_state.config.outputs.public_dns_zone_id
  infrastructure_name   = data.terraform_remote_state.config.outputs.infrastructure_name

  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.network.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  tags = {
    Project = "ocp-aws-non-integrated"
    Env     = "dev"
  }
}