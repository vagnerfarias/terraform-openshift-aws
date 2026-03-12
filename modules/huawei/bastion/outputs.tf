output "bastion_instance_id" {
  value = huaweicloud_compute_instance.bastion.id
}

output "bastion_name" {
  value = huaweicloud_compute_instance.bastion.name
}

output "bastion_public_ip" {
  value = huaweicloud_vpc_eip.bastion.address
}

output "bastion_private_ip" {
  value = huaweicloud_compute_instance.bastion.access_ip_v4
}

output "bastion_security_group_id" {
  value = var.bastion_security_group_id
}