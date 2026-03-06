output "bootstrap_instance_id" {
  value = aws_instance.bootstrap.id
}

output "bootstrap_private_ip" {
  value = aws_instance.bootstrap.private_ip
}