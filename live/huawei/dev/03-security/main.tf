locals {
  api_elb_source_cidrs = distinct(concat(
    [data.terraform_remote_state.edge.outputs.public_elb_backend_subnet_cidr],
    [data.terraform_remote_state.edge.outputs.private_elb_backend_subnet_cidr],
    var.extra_api_elb_source_cidrs
  ))

  apps_elb_source_cidrs = distinct(concat(
    [data.terraform_remote_state.edge.outputs.public_elb_backend_subnet_cidr],
    var.extra_apps_elb_source_cidrs
  ))
}

module "security" {
  source = "../../../../modules/huawei/security"

  infrastructure_name = data.terraform_remote_state.config.outputs.infrastructure_name
  vpc_cidr            = data.terraform_remote_state.network.outputs.vpc_cidr
  allowed_ssh_cidr    = var.allowed_ssh_cidr

  api_elb_source_cidrs  = local.api_elb_source_cidrs
  apps_elb_source_cidrs = local.apps_elb_source_cidrs

  tags = var.tags
}