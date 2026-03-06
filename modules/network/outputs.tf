output "vpc_id" {
  value = aws_vpc.this.id
}

output "azs" {
  value = local.azs
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

# mapa AZ -> public subnet
output "public_subnets_by_az" {
  value = {
    for i, az in local.azs :
    az => aws_subnet.public[i].id
  }
}

# mapa AZ -> private subnet
output "private_subnets_by_az" {
  value = {
    for i, az in local.azs :
    az => aws_subnet.private[i].id
  }
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}

output "private_subnet_cidrs" {
  value = aws_subnet.private[*].cidr_block
}

output "public_subnet_cidrs" {
  value = aws_subnet.public[*].cidr_block
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}