output "cluster_name"          { value = var.cluster_name }
output "base_domain"           { value = var.base_domain }
output "public_hosted_zone_id" { value = var.public_hosted_zone_id }
output "aws_region"            { value = var.aws_region }

output "infrastructure_name" { value = var.infrastructure_name }
output "ignition_bucket"     { value = var.ignition_bucket }
output "ignition_prefix"     { value = var.ignition_prefix }

output "rhcos_ami_id"         { value = var.rhcos_ami_id }
output "bootstrap_ignition_url" { value = var.bootstrap_ignition_url }
output "master_ignition_url"    { value = var.master_ignition_url }
output "worker_ignition_url"    { value = var.worker_ignition_url }