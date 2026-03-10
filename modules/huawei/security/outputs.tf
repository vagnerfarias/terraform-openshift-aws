output "bastion_security_group_id" {
  value = huaweicloud_networking_secgroup.bastion.id
}

output "control_plane_security_group_id" {
  value = huaweicloud_networking_secgroup.control_plane.id
}

output "worker_security_group_id" {
  value = huaweicloud_networking_secgroup.worker.id
}