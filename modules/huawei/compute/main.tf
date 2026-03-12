locals {
  common_tags = var.tags

  workers = {
    for idx in range(var.instance_count) : idx => {
      name              = format("%s-worker-%d", var.infrastructure_name, idx)
      subnet_id         = var.subnet_ids[idx % length(var.subnet_ids)]
      availability_zone = var.availability_zones[idx % length(var.availability_zones)]
    }
  }

  user_data = base64encode(jsonencode({
    ignition = {
      version = "3.2.0"
      config = {
        replace = {
          source = var.worker_ignition_url
        }
      }
    }
  }))
}

resource "huaweicloud_compute_instance" "worker" {
  for_each = local.workers

  name              = each.value.name
  image_id          = var.rhcos_image_id
  flavor_id         = var.flavor_id
  availability_zone = each.value.availability_zone
  security_groups   = [var.worker_security_group_id]

  network {
    uuid = each.value.subnet_id
  }

  system_disk_type = var.system_disk_type
  system_disk_size = var.system_disk_size

  user_data = local.user_data
  metadata  = var.metadata

  admin_pass = var.admin_pass != "" ? var.admin_pass : null
  key_pair   = var.key_pair != "" ? var.key_pair : null

  tags = local.common_tags
}

resource "huaweicloud_lb_member" "apps_http" {
  for_each = huaweicloud_compute_instance.worker

  pool_id       = var.apps_http_pool_id
  address       = each.value.access_ip_v4
  subnet_id     = local.workers[tonumber(each.key)].subnet_id
  protocol_port = 80
  weight        = 1
}

resource "huaweicloud_lb_member" "apps_https" {
  for_each = huaweicloud_compute_instance.worker

  pool_id       = var.apps_https_pool_id
  address       = each.value.access_ip_v4
  subnet_id     = local.workers[tonumber(each.key)].subnet_id
  protocol_port = 443
  weight        = 1
}