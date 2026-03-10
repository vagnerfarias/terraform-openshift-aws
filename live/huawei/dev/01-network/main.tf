module "network" {
  source = "../../../../modules/huawei/network"

  infrastructure_name = data.terraform_remote_state.config.outputs.infrastructure_name
  cloud_region        = data.terraform_remote_state.config.outputs.cloud_region

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone  = var.availability_zone
  tags               = var.tags
}