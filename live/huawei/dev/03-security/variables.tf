variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to access the bastion over SSH."
}

variable "extra_api_elb_source_cidrs" {
  type        = list(string)
  default     = []
  description = "Extra CIDRs to allow to API/MCS backends."
}

variable "extra_apps_elb_source_cidrs" {
  type        = list(string)
  default     = []
  description = "Extra CIDRs to allow to ingress backends."
}

variable "tags" {
  type        = map(string)
  default     = {}
}