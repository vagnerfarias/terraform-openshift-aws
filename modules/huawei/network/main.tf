data "huaweicloud_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(
    data.huaweicloud_availability_zones.available.names,
    0,
    var.availability_zone_count
  )

  # Preserve the current repo pattern:
  # - first N subnets: public
  # - next N subnets: private
  # - final subnet: dedicated NAT subnet
  public_subnet_cidrs = [
    for i in range(var.availability_zone_count) :
    cidrsubnet(var.vpc_cidr, var.subnet_bits, i)
  ]

  private_subnet_cidrs = [
    for i in range(var.availability_zone_count) :
    cidrsubnet(var.vpc_cidr, var.subnet_bits, i + var.availability_zone_count)
  ]

  nat_subnet_cidr = cidrsubnet(
    var.vpc_cidr,
    var.subnet_bits,
    var.availability_zone_count * 2
  )

  common_tags = var.tags
}

resource "huaweicloud_vpc" "this" {
  name = var.vpc_name
  cidr = var.vpc_cidr
  tags = local.common_tags
}

resource "huaweicloud_vpc_subnet" "public" {
  count = var.availability_zone_count

  name              = "${var.vpc_name}-public-${local.azs[count.index]}"
  cidr              = local.public_subnet_cidrs[count.index]
  gateway_ip        = cidrhost(local.public_subnet_cidrs[count.index], 1)
  vpc_id            = huaweicloud_vpc.this.id
  availability_zone = local.azs[count.index]
  dhcp_enable       = var.dhcp_enable
  primary_dns       = var.primary_dns
  secondary_dns     = var.secondary_dns
  dns_list          = var.dns_list
  tags              = local.common_tags
}

resource "huaweicloud_vpc_subnet" "private" {
  count = var.availability_zone_count

  name              = "${var.vpc_name}-private-${local.azs[count.index]}"
  cidr              = local.private_subnet_cidrs[count.index]
  gateway_ip        = cidrhost(local.private_subnet_cidrs[count.index], 1)
  vpc_id            = huaweicloud_vpc.this.id
  availability_zone = local.azs[count.index]
  dhcp_enable       = var.dhcp_enable
  primary_dns       = var.primary_dns
  secondary_dns     = var.secondary_dns
  dns_list          = var.dns_list
  tags              = local.common_tags
}

# Dedicated subnet for the public NAT gateway, following Huawei guidance.
resource "huaweicloud_vpc_subnet" "nat" {
  name              = "${var.vpc_name}-nat-${local.azs[0]}"
  cidr              = local.nat_subnet_cidr
  gateway_ip        = cidrhost(local.nat_subnet_cidr, 1)
  vpc_id            = huaweicloud_vpc.this.id
  availability_zone = local.azs[0]
  dhcp_enable       = var.dhcp_enable
  primary_dns       = var.primary_dns
  secondary_dns     = var.secondary_dns
  dns_list          = var.dns_list
  tags              = local.common_tags
}

resource "huaweicloud_vpc_eip" "nat" {
  name = "${var.vpc_name}-nat-eip"

  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "${var.vpc_name}-nat-bw"
    size        = var.nat_eip_bandwidth_size
    charge_mode = var.nat_eip_bandwidth_charge_mode
  }

  tags = local.common_tags
}

resource "huaweicloud_nat_gateway" "this" {
  name        = "${var.vpc_name}-natgw"
  description = "NAT gateway for private OpenShift subnets"
  spec        = var.nat_gateway_spec
  vpc_id      = huaweicloud_vpc.this.id
  subnet_id   = huaweicloud_vpc_subnet.nat.id
}

resource "huaweicloud_nat_snat_rule" "private" {
  for_each = {
    for idx, subnet in huaweicloud_vpc_subnet.private :
    idx => subnet
  }

  nat_gateway_id = huaweicloud_nat_gateway.this.id
  floating_ip_id = huaweicloud_vpc_eip.nat.id
  subnet_id      = each.value.id
  description    = "SNAT for ${each.value.name}"
}

resource "huaweicloud_vpc_route_table" "private" {
  name        = "${var.vpc_name}-private-rt"
  vpc_id      = huaweicloud_vpc.this.id
  description = "Custom route table for private OpenShift subnets"

  subnets = huaweicloud_vpc_subnet.private[*].id

  route {
    destination = "0.0.0.0/0"
    type        = "nat"
    nexthop     = huaweicloud_nat_gateway.this.id
    description = "Default route to public NAT gateway"
  }
}