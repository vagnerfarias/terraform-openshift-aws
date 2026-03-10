module "security" {
  source = "../../../../modules/huawei/security"

  infrastructure_name = data.terraform_remote_state.config.outputs.infrastructure_name
  vpc_cidr            = data.terraform_remote_state.network.outputs.vpc_cidr
  allowed_ssh_cidr    = var.allowed_ssh_cidr

  elb_mode               = var.elb_mode
  elb_shared_source_cidrs = var.elb_shared_source_cidrs
  elb_backend_subnet_cidr = var.elb_backend_subnet_cidr

  tags = var.tags
}