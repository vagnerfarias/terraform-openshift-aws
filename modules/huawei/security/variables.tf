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

variable "elb_mode" {
  type        = string
  description = "ELB mode: shared or dedicated."
  default     = "shared"

  validation {
    condition     = contains(["shared", "dedicated"], var.elb_mode)
    error_message = "elb_mode must be either 'shared' or 'dedicated'."
  }
}

variable "elb_shared_source_cidrs" {
  type        = list(string)
  description = "Source CIDRs used by shared ELB for backend traffic and health checks."
  default     = ["100.125.0.0/16", "100.126.0.0/16"]
}

variable "elb_backend_subnet_cidr" {
  type        = string
  description = "Backend subnet CIDR used by a dedicated ELB."
  default     = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied where supported."
}