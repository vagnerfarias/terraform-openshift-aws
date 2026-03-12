locals {
  name_prefix = var.infrastructure_name
}

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

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_geneve" {
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

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_ssh_from_vpc" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 7
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  priority          = 1
}

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

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_nodeport_vpc" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "30000-32767"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 3
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_kubelet_vpc" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "10250"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 4
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_geneve_vpc" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  ports             = "6081"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 5
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_vxlan_vpc" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  ports             = "4789"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 6
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_ssh_from_vpc" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22"
  remote_ip_prefix  = var.vpc_cidr
  priority          = 7
}

resource "huaweicloud_networking_secgroup_rule" "worker_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  priority          = 1
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_api_elb" {
  for_each = {
    for idx, cidr in var.api_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "6443"
  remote_ip_prefix  = each.value
  priority          = 100 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "control_plane_ingress_mcs_elb" {
  for_each = {
    for idx, cidr in var.api_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.control_plane.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "22623"
  remote_ip_prefix  = each.value
  priority          = 120 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_http_elb" {
  for_each = {
    for idx, cidr in var.apps_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "80"
  remote_ip_prefix  = each.value
  priority          = 140 + tonumber(each.key)
}

resource "huaweicloud_networking_secgroup_rule" "worker_ingress_https_elb" {
  for_each = {
    for idx, cidr in var.apps_elb_source_cidrs : idx => cidr
  }

  security_group_id = huaweicloud_networking_secgroup.worker.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  ports             = "443"
  remote_ip_prefix  = each.value
  priority          = 160 + tonumber(each.key)
}