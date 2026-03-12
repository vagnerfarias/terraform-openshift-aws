output "api_public_lb_id" {
  value = huaweicloud_lb_loadbalancer.api_public.id
}

output "api_public_lb_address" {
  value = huaweicloud_vpc_eip.api_public.address
}

output "api_private_lb_id" {
  value = huaweicloud_lb_loadbalancer.api_private.id
}

output "api_private_lb_address" {
  value = huaweicloud_lb_loadbalancer.api_private.vip_address
}

output "apps_public_lb_id" {
  value = huaweicloud_lb_loadbalancer.apps_public.id
}

output "apps_public_lb_address" {
  value = huaweicloud_vpc_eip.apps_public.address
}

output "api_public_pool_id" {
  value = huaweicloud_lb_pool.api_public.id
}

output "api_private_pool_id" {
  value = huaweicloud_lb_pool.api_private.id
}

output "mcs_private_pool_id" {
  value = huaweicloud_lb_pool.mcs_private.id
}

output "apps_http_pool_id" {
  value = huaweicloud_lb_pool.apps_http.id
}

output "apps_https_pool_id" {
  value = huaweicloud_lb_pool.apps_https.id
}

output "public_dns_zone_id" {
  value = var.public_dns_zone_id
}

output "private_dns_zone_id" {
  value = local.private_zone_id
}

output "api_public_dns_name" {
  value = local.api_fqdn
}

output "api_private_dns_name" {
  value = local.api_fqdn
}

output "api_int_private_dns_name" {
  value = local.api_int_fqdn
}

output "apps_public_dns_name" {
  value = local.apps_wildcard_fqdn
}

output "public_elb_backend_subnet_cidr" {
  value = local.public_subnet_cidr
}

output "private_elb_backend_subnet_cidr" {
  value = local.private_subnet_cidr
}