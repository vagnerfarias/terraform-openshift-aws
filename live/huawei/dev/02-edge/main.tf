module "edge" {
  source = "../../../../modules/huawei/edge"

  cluster_name        = data.terraform_remote_state.config.outputs.cluster_name
  base_domain         = data.terraform_remote_state.config.outputs.base_domain
  infrastructure_name = data.terraform_remote_state.config.outputs.infrastructure_name
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id

  public_subnet_ids   = data.terraform_remote_state.network.outputs.public_subnet_ids
  private_subnet_ids  = data.terraform_remote_state.network.outputs.private_subnet_ids
  public_subnet_cidrs = data.terraform_remote_state.network.outputs.public_subnet_cidrs
  private_subnet_cidrs = data.terraform_remote_state.network.outputs.private_subnet_cidrs

  manage_public_dns  = var.manage_public_dns
  public_dns_zone_id = data.terraform_remote_state.config.outputs.public_dns_zone_id

  manage_private_dns = var.manage_private_dns
  private_dns_zone_id = var.private_dns_zone_id

  public_dns_ttl  = var.public_dns_ttl
  private_dns_ttl = var.private_dns_ttl

  public_eip_bandwidth_size        = var.public_eip_bandwidth_size
  public_eip_bandwidth_charge_mode = var.public_eip_bandwidth_charge_mode

  api_listener_port         = var.api_listener_port
  api_private_listener_port = var.api_private_listener_port
  mcs_listener_port         = var.mcs_listener_port
  apps_http_listener_port   = var.apps_http_listener_port
  apps_https_listener_port  = var.apps_https_listener_port

  apps_healthcheck_port = var.apps_healthcheck_port
  apps_healthcheck_path = var.apps_healthcheck_path

  api_monitor_delay   = var.api_monitor_delay
  api_monitor_timeout = var.api_monitor_timeout
  api_monitor_retries = var.api_monitor_retries

  apps_monitor_delay   = var.apps_monitor_delay
  apps_monitor_timeout = var.apps_monitor_timeout
  apps_monitor_retries = var.apps_monitor_retries

  tags = var.tags
}