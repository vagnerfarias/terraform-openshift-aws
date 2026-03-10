output "private_dns_zone_id" {
  value = aws_route53_zone.private_cluster_zone.zone_id
}

output "external_api_target_group_arn" {
  value = aws_lb_target_group.ext_api_6443.arn
}

output "internal_api_target_group_arn" {
  value = aws_lb_target_group.int_api_6443.arn
}

output "internal_service_target_group_arn" {
  value = aws_lb_target_group.int_svc_22623.arn
}

output "external_api_nlb_dns_name" {
  value = aws_lb.ext_api.dns_name
}

output "internal_api_nlb_dns_name" {
  value = aws_lb.int_api.dns_name
}

output "api_server_dns_name" {
  description = "Internal API server DNS name used by installer/ignition."
  value       = "api-int.${var.cluster_name}.${var.base_domain}"
}

output "api_dns_name" {
  description = "Public API DNS name."
  value       = "api.${var.cluster_name}.${var.base_domain}"
}

output "apps_http_target_group_arn" {
  value = aws_lb_target_group.apps_http_80.arn
}

output "apps_https_target_group_arn" {
  value = aws_lb_target_group.apps_https_443.arn
}

output "apps_nlb_dns_name" {
  value = aws_lb.apps.dns_name
}