locals {
  name_prefix = var.infrastructure_name

  shared_elb_source_cidrs = var.elb_mode == "shared" ? var.elb_shared_source_cidrs : []

  dedicated_elb_source_cidrs = (
    var.elb_mode == "dedicated" && var.elb_backend_subnet_cidr != ""
  ) ? [var.elb_backend_subnet_cidr] : []
}

#
# Security groups
#

resource "huaweicloud_networking_secgroup" "bastion" {
  name                 = "${local.name_prefix}-bastion-sg"
  description          = "Bastion security group"
  delete_default_rules = true
}

resource "huaweicloud_networking_secgroup" "control_plane" {
  name                 = "${local.name_prefix}-control-plane-sg"
  description          = "OpenShift control plane security group"
  delete_default_rules = true
}

resource "huaweicloud_networking_secgroup" "worker" {
  name                 = "${local.name_prefix}-worker-sg"
  description          = "OpenShift worker security group"
  delete_default_rules = true
}

#
# Bastion rules
#

resource "huaweicloud_networking_secgroup_rule" "bastion_ingress_ssh" {
  security_group_id = huaweicloud_networking_secgroup.bastion.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22"
  remote_ip_prefix  = var.allowed_ssh_cidr
  priority          = 1
}

resource "huaweicloud_networking_secgroup_rule" "bastion_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.bastion.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  priority          = 1
}

#
# Control plane rules
#

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_api_vpc" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "6443"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 1
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_mcs_vpc" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22623"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 2
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_etcd_peer" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "2379-2380"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 3
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_kubelet" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "10250-10259"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 4
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_overlay_geneve" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  ports             = "6081"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 5
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_vxlan" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  ports             = "4789"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 6
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_bastion_ssh" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 9
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  priority          = 1
}

#
# Worker rules
#

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_http_vpc" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "80"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 1
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_https_vpc" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "443"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 2
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "30000-32767"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 3
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_kubelet" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "10250"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 4
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_overlay_geneve" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  ports             = "6081"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 5
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_vxlan" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  ports             = "4789"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 6
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_bastion_ssh" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 9
}

resource "huaweicloud_networking_secgroup_rule" "worker_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  priority          = 1
}

#
# Shared ELB source CIDRs
# Huawei docs say shared ELB backend traffic/health checks come from
# 100.125.0.0/16 and 100.126.0.0/16.
#

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_elb_api_shared" {
  for_each = {
    for idx, cidr in local.shared_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "6443"
  remote_ip_prefix  = each.value
  priority          = 100 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_elb_mcs_shared" {
  for_each = {
    for idx, cidr in local.shared_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22623"
  remote_ip_prefix  = each.value
  priority          = 110 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_elb_http_shared" {
  for_each = {
    for idx, cidr in local.shared_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "80"
  remote_ip_prefix  = each.value
  priority          = 120 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_elb_https_shared" {
  for_each = {
    for idx, cidr in local.shared_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "443"
  remote_ip_prefix  = each.value
  priority          = 130 + tonumber(each.key)
}

#
# Dedicated ELB backend subnet
# Huawei docs say dedicated ELB health checks/backend traffic come from the
# backend subnet where the ELB works.
#

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_elb_api_dedicated" {
  for_each = {
    for idx, cidr in local.dedicated_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "6443"
  remote_ip_prefix  = each.value
  priority          = 140 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_elb_mcs_dedicated" {
  for_each = {
    for idx, cidr in local.dedicated_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22623"
  remote_ip_prefix  = each.value
  priority          = 150 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_elb_http_dedicated" {
  for_each = {
    for idx, cidr in local.dedicated_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "80"
  remote_ip_prefix  = each.value
  priority          = 160 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_elb_https_dedicated" {
  for_each = {
    for idx, cidr in local.dedicated_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
 ports             = "443"
  remote_ip_prefix  = each.value
  priority          = 170 + tonumber(each.key)
}