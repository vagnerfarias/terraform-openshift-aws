variable "infrastructure_name" {
  type = string
}

variable "rhcos_ami_id" {
  type = string
}

variable "master_ignition_url" {
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
  default = 3
}

variable "external_api_target_group_arn" {
  type = string
}

variable "internal_api_target_group_arn" {
  type = string
}

variable "internal_service_target_group_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}