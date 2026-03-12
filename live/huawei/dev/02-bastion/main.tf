module "bastion" {
  source = "../../../../modules/huawei/bastion"

  name                      = "${data.terraform_remote_state.config.outputs.infrastructure_name}-bastion"
  image_id                  = var.image_id
  flavor_id                 = var.flavor_id
  subnet_id                 = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  bastion_security_group_id = data.terraform_remote_state.security.outputs.bastion_security_group_id
  availability_zone         = data.terraform_remote_state.network.outputs.azs[0]

  system_disk_size = var.system_disk_size
  system_disk_type = var.system_disk_type
  key_pair         = var.key_pair
  admin_pass       = var.admin_pass
  user_data        = var.user_data

  public_eip_bandwidth_size        = var.public_eip_bandwidth_size
  public_eip_bandwidth_charge_mode = var.public_eip_bandwidth_charge_mode

  metadata = var.metadata
  tags     = var.tags
}