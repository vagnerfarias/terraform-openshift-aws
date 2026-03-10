output "private_hosted_zone_id" {
  value = module.edge.private_hosted_zone_id
}

output "api_server_dns_name" {
  value = module.edge.api_server_dns_name
}

output "external_api_target_group_arn" {
  value = module.edge.external_api_target_group_arn
}

output "internal_api_target_group_arn" {
  value = module.edge.internal_api_target_group_arn
}

output "internal_service_target_group_arn" {
  value = module.edge.internal_service_target_group_arn
}

output "apps_http_target_group_arn" {
  value = module.edge.apps_http_target_group_arn
}

output "apps_https_target_group_arn" {
  value = module.edge.apps_https_target_group_arn
}

output "apps_nlb_dns_name" {
  value = module.edge.apps_nlb_dns_name
}