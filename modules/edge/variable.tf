variable "cluster_name" { type = string }
variable "base_domain"  { type = string } 
variable "infrastructure_name" { type = string }

variable "public_hosted_zone_id" { type = string }

variable "vpc_id" { type = string }
variable "public_subnet_ids"  { type = list(string) }
variable "private_subnet_ids" { type = list(string) }

variable "tags" {
  type    = map(string)
  default = {}
}