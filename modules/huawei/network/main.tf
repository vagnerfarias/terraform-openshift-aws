resource "terraform_data" "network" {
  input = {
    infrastructure_name = var.infrastructure_name
    cloud_region        = var.cloud_region
    vpc_cidr            = var.vpc_cidr
    public_subnet_cidr  = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    availability_zone   = var.availability_zone
  }
}