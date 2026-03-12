locals {
  bootstrap_name = "${var.infrastructure_name}-bootstrap"

  user_data = base64encode(jsonencode({
    ignition = {
      version = "3.2.0"
      config = {
        replace = {
          source = var.bootstrap_ignition_url
        }
      }
    }
  }))
}

resource "huaweicloud_compute_instance" "bootstrap" {
  name              = local.bootstrap_name
  image_id          = var.rhcos_image_id
  flavor_id         = var.flavor_id
  availability_zone = var.availability_zone
  security_groups   = [var.control_plane_security_group_id]

  network {
    uuid = var.subnet_id
  }

  system_disk_type = var.system_disk_type
  system_disk_size = var.system_disk_size

  user_data = local.user_data
  metadata  = var.metadata

  admin_pass = var.admin_pass != "" ? var.admin_pass : null
  key_pair   = var.key_pair != "" ? var.key_pair : null

  tags = var.tags
}

resource "huaweicloud_lb_member" "api_public" {
  pool_id       = var.api_public_pool_id
  address       = huaweicloud_compute_instance.bootstrap.access_ip_v4
  subnet_id     = var.subnet_id
  protocol_port = 6443
  weight        = 1
}

resource "huaweicloud_lb_member" "api_private" {
  pool_id       = var.api_private_pool_id
  address       = huaweicloud_compute_instance.bootstrap.access_ip_v4
  subnet_id     = var.subnet_id
  protocol_port = 6443
  weight        = 1
}

resource "huaweicloud_lb_member" "mcs_private" {
  pool_id       = var.mcs_private_pool_id
  address       = huaweicloud_compute_instance.bootstrap.access_ip_v4
  subnet_id     = var.subnet_id
  protocol_port = 22623
  weight        = 1
}