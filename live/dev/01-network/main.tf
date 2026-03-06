module "network" {
  source = "../../../modules/network"

  vpc_cidr                = "10.0.0.0/16"
  availability_zone_count = 1
  subnet_bits             = 8
  vpc_name                = "cluster-vpc"
}