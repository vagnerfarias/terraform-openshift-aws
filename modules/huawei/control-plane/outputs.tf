output "instance_ids" {
  value = [for v in huaweicloud_compute_instance.master : v.id]
}

output "instance_names" {
  value = [for v in huaweicloud_compute_instance.master : v.name]
}

output "instance_private_ips" {
  value = [for v in huaweicloud_compute_instance.master : v.access_ip_v4]
}