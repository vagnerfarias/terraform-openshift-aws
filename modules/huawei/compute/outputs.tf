output "instance_ids" {
  value = [for v in huaweicloud_compute_instance.worker : v.id]
}

output "instance_names" {
  value = [for v in huaweicloud_compute_instance.worker : v.name]
}

output "instance_private_ips" {
  value = [for v in huaweicloud_compute_instance.worker : v.access_ip_v4]
}