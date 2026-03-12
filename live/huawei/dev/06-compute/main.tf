module "compute" {
  source = "../../../../modules/huawei/compute"

  infrastructure_name       = data.terraform_remote_state.config.outputs.infrastructure_name
  rhcos_image_id            = data.terraform_remote_state.config.outputs.rhcos_image_id
  worker_ignition_url       = data.terraform_remote_state.config.outputs.worker_ignition_url
  subnet_ids                = data.terraform_remote_state.network.outputs.private_subnet_ids
  availability_zones        = data.terraform_remote_state.network.outputs.azs
  worker_security_group_id  = data.terraform_remote_state.security.outputs.worker_security_group_id

  apps_http_pool_id  = data.terraform_remote_state.edge.outputs.apps_http_pool_id
  apps_https_pool_id = data.terraform_remote_state.edge.outputs.apps_https_pool_id

  instance_count   = var.instance_count
  flavor_id        = var.flavor_id
  system_disk_size = var.system_disk_size
  system_disk_type = var.system_disk_type
  admin_pass       = var.admin_pass
  key_pair         = var.key_pair
  metadata         = var.metadata
  tags             = var.tags
}