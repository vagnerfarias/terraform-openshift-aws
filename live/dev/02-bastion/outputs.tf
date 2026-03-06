output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_public_dns" {
  value = aws_instance.bastion.public_dns
}

output "bastion_ssh_user" {
  value = local.ssh_user
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}