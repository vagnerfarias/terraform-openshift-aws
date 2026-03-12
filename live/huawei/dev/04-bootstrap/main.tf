module "bootstrap" {
  source = "../../../../modules/huawei/bootstrap"

  infrastructure_name              = data.terraform_remote_state.config.outputs.infrastructure_name
  rhcos_image_id                   = data.terraform_remote_state.config.outputs.rhcos_image_id
  bootstrap_ignition_url           = data.terraform_remote_state.config.outputs.bootstrap_ignition_url
  subnet_id                        = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
  availability_zone                = data.terraform_remote_state.network.outputs.azs[0]
  control_plane_security_group_id  = data.terraform_remote_state.security.outputs.control_plane_security_group_id

  api_public_pool_id  = data.terraform_remote_state.edge.outputs.api_public_pool_id
  api_private_pool_id = data.terraform_remote_state.edge.outputs.api_private_pool_id
  mcs_private_pool_id = data.terraform_remote_state.edge.outputs.mcs_private_pool_id

  flavor_id        = var.flavor_id
  system_disk_size = var.system_disk_size
  system_disk_type = var.system_disk_type
  admin_pass       = var.admin_pass
  key_pair         = var.key_pair
  metadata         = var.metadata
  tags             = var.tags
}