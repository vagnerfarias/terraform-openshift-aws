output "api_public_lb_id" {
  value = module.edge.api_public_lb_id
}

output "api_public_lb_address" {
  value = module.edge.api_public_lb_address
}

output "api_private_lb_id" {
  value = module.edge.api_private_lb_id
}

output "api_private_lb_address" {
  value = module.edge.api_private_lb_address
}

output "apps_public_lb_id" {
  value = module.edge.apps_public_lb_id
}

output "apps_public_lb_address" {
  value = module.edge.apps_public_lb_address
}

output "api_public_pool_id" {
  value = module.edge.api_public_pool_id
}

output "api_private_pool_id" {
  value = module.edge.api_private_pool_id
}

output "mcs_private_pool_id" {
  value = module.edge.mcs_private_pool_id
}

output "apps_http_pool_id" {
  value = module.edge.apps_http_pool_id
}

output "apps_https_pool_id" {
  value = module.edge.apps_https_pool_id
}

output "private_dns_zone_id" {
  value = module.edge.private_dns_zone_id
}

output "public_elb_backend_subnet_cidr" {
  value = module.edge.public_elb_backend_subnet_cidr
}

output "private_elb_backend_subnet_cidr" {
  value = module.edge.private_elb_backend_subnet_cidr
}