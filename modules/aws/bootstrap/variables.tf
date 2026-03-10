variable "infrastructure_name" { type = string }
variable "rhcos_image_id"        { type = string }
variable "bootstrap_ignition_url" { type = string }

variable "subnet_id" { type = string }

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

variable "external_api_target_group_arn" { type = string }
variable "internal_api_target_group_arn" { type = string }
variable "internal_service_target_group_arn" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}