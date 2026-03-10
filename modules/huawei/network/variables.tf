variable "infrastructure_name" {
  type        = string
  description = "Prefix used for network resources."
}

variable "cloud_region" {
  type        = string
  description = "Huawei Cloud region."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet."
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR for the private subnet."
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for subnet placement."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags."
}