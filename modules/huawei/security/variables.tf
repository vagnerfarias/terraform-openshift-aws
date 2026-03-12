variable "infrastructure_name" {
  type        = string
  description = "Prefix for resource names."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR."
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to access the bastion over SSH."
}

variable "api_elb_source_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach API/MCS backends from ELB."
  default     = []
}

variable "apps_elb_source_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach ingress backends from ELB."
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied where supported."
}