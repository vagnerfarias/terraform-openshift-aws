variable "vpc_cidr" {
  type        = string
  description = "CIDR for the Huawei Cloud VPC."
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
  description = "Huawei Cloud availability zone."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied where supported."
}