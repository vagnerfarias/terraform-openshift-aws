module "network" {
  source = "../../../../modules/huawei/network"

  vpc_cidr                = var.vpc_cidr
  availability_zone_count = var.availability_zone_count
  subnet_bits             = var.subnet_bits
  vpc_name                = data.terraform_remote_state.config.outputs.infrastructure_name

  nat_gateway_spec               = var.nat_gateway_spec
  nat_eip_bandwidth_size         = var.nat_eip_bandwidth_size
  nat_eip_bandwidth_charge_mode  = var.nat_eip_bandwidth_charge_mode

  primary_dns   = var.primary_dns
  secondary_dns = var.secondary_dns
  dns_list      = var.dns_list
  dhcp_enable   = var.dhcp_enable
  tags          = var.tags
}