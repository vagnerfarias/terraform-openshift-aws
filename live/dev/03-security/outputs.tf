output "master_security_group_id" {
  value = module.security.master_security_group_id
}

output "worker_security_group_id" {
  value = module.security.worker_security_group_id
}

output "master_instance_profile_name" {
  value = module.security.master_instance_profile_name
}

output "worker_instance_profile_name" {
  value = module.security.worker_instance_profile_name
}