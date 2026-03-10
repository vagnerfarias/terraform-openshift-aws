variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC."
}

variable "availability_zone_count" {
  type        = number
  description = "Number of AZs to use (1–3)."
}

variable "subnet_bits" {
  type        = number
  description = "Subnet bits used with cidrsubnet()."
}

variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
}