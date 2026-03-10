output "bastion_security_group_id" {
  value = module.security.bastion_security_group_id
}

output "control_plane_security_group_id" {
  value = module.security.control_plane_security_group_id
}

output "worker_security_group_id" {
  value = module.security.worker_security_group_id
}