variable "infrastructure_name" {
  type = string
}

variable "rhcos_ami_id" {
  type = string
}

variable "worker_ignition_url" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_profile_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "m6i.xlarge"
}

variable "root_volume_size" {
  type    = number
  default = 120
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "apps_http_target_group_arn" {
  type    = string
  default = ""
}

variable "apps_https_target_group_arn" {
  type    = string
  default = ""
}