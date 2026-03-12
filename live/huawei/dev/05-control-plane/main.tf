module "control_plane" {
  source = "../../../../modules/huawei/control-plane"

  infrastructure_name            = data.terraform_remote_state.config.outputs.infrastructure_name
  rhcos_image_id                 = data.terraform_remote_state.config.outputs.rhcos_image_id
  master_ignition_url            = data.terraform_remote_state.config.outputs.master_ignition_url
  subnet_ids                     = data.terraform_remote_state.network.outputs.private_subnet_ids
  availability_zones             = data.terraform_remote_state.network.outputs.azs
  control_plane_security_group_id = data.terraform_remote_state.security.outputs.control_plane_security_group_id

  api_public_pool_id  = data.terraform_remote_state.edge.outputs.api_public_pool_id
  api_private_pool_id = data.terraform_remote_state.edge.outputs.api_private_pool_id
  mcs_private_pool_id = data.terraform_remote_state.edge.outputs.mcs_private_pool_id

  instance_count   = var.instance_count
  flavor_id        = var.flavor_id
  system_disk_size = var.system_disk_size
  system_disk_type = var.system_disk_type
  admin_pass       = var.admin_pass
  key_pair         = var.key_pair
  metadata         = var.metadata
  tags             = var.tags
}