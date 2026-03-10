output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "bastion_public_dns" {
  value = module.bastion.bastion_public_dns
}

output "bastion_ssh_user" {
  value = module.bastion.bastion_ssh_user
}

output "bastion_instance_id" {
  value = module.bastion.bastion_instance_id
}

output "bastion_security_group_id" {
  value = module.bastion.bastion_security_group_id
}