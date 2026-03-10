locals {
  common_tags = merge(
    {
      Project = "ocp-aws-non-integrated"
      Env     = "dev"
      Name    = "ocp-bastion"
    },
    var.tags
  )
}

module "bastion" {
  source = "../../../modules/aws/bastion"

  name             = "ocp-bastion"
  vpc_id           = data.terraform_remote_state.network.outputs.vpc_id
  subnet_id        = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  allowed_ssh_cidr = var.allowed_ssh_cidr
  instance_type    = var.instance_type
  root_volume_gb   = var.root_volume_gb
  ami_id           = var.ami_id
  key_name         = var.key_name
  public_key_path  = var.public_key_path
  manage_key_pair  = var.manage_key_pair
  tags             = local.common_tags
}