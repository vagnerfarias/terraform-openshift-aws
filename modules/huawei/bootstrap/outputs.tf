output "instance_id" {
  value = huaweicloud_compute_instance.bootstrap.id
}

output "instance_name" {
  value = huaweicloud_compute_instance.bootstrap.name
}

output "instance_private_ip" {
  value = huaweicloud_compute_instance.bootstrap.access_ip_v4
}