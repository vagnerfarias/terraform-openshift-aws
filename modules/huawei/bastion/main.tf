locals {
  encoded_user_data = var.user_data != "" ? base64encode(var.user_data) : null
}

resource "huaweicloud_compute_instance" "bastion" {
  name              = var.name
  image_id          = var.image_id
  flavor_id         = var.flavor_id
  availability_zone = var.availability_zone
  security_groups   = [var.bastion_security_group_id]

  network {
    uuid = var.subnet_id
  }

  system_disk_type = var.system_disk_type
  system_disk_size = var.system_disk_size

  user_data = local.encoded_user_data
  metadata  = var.metadata

  admin_pass = var.admin_pass != "" ? var.admin_pass : null
  key_pair   = var.key_pair != "" ? var.key_pair : null

  tags = var.tags
}

resource "huaweicloud_vpc_eip" "bastion" {
  name = "${var.name}-eip"

  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "${var.name}-bw"
    size        = var.public_eip_bandwidth_size
    charge_mode = var.public_eip_bandwidth_charge_mode
  }

  tags = var.tags
}

resource "huaweicloud_compute_eip_associate" "bastion" {
  public_ip   = huaweicloud_vpc_eip.bastion.address
  instance_id = huaweicloud_compute_instance.bastion.id
}