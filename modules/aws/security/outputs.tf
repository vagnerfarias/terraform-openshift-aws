output "master_security_group_id" {
  value = aws_security_group.master.id
}

output "worker_security_group_id" {
  value = aws_security_group.worker.id
}

output "master_instance_profile_name" {
  value = aws_iam_instance_profile.master.name
}

output "worker_instance_profile_name" {
  value = aws_iam_instance_profile.worker.name
}