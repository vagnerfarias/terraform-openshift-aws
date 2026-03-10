output "vpc_id" {
  value = huaweicloud_vpc.this.id
}

output "azs" {
  value = local.azs
}

output "public_subnet_ids" {
  value = huaweicloud_vpc_subnet.public[*].id
}

output "private_subnet_ids" {
  value = huaweicloud_vpc_subnet.private[*].id
}

output "nat_subnet_id" {
  value = huaweicloud_vpc_subnet.nat.id
}

output "public_subnets_by_az" {
  value = {
    for i, az in local.azs :
    az => huaweicloud_vpc_subnet.public[i].id
  }
}

output "private_subnets_by_az" {
  value = {
    for i, az in local.azs :
    az => huaweicloud_vpc_subnet.private[i].id
  }
}

output "private_route_table_ids" {
  value = [huaweicloud_vpc_route_table.private.id]
}

output "public_route_table_id" {
  value = null
}

output "private_subnet_cidrs" {
  value = huaweicloud_vpc_subnet.private[*].cidr
}

output "public_subnet_cidrs" {
  value = huaweicloud_vpc_subnet.public[*].cidr
}

output "nat_subnet_cidr" {
  value = huaweicloud_vpc_subnet.nat.cidr
}

output "vpc_cidr" {
  value = huaweicloud_vpc.this.cidr
}

output "nat_gateway_id" {
  value = huaweicloud_nat_gateway.this.id
}

output "nat_eip_id" {
  value = huaweicloud_vpc_eip.nat.id
}

output "nat_eip_address" {
  value = huaweicloud_vpc_eip.nat.address
}