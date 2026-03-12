variable "image_id" {
  type        = string
  description = "Image ID for the bastion instance."
}

variable "flavor_id" {
  type        = string
  description = "Huawei Cloud ECS flavor ID for the bastion instance."
}

variable "system_disk_size" {
  type    = number
  default = 40
}

variable "system_disk_type" {
  type    = string
  default = "SSD"
}

variable "key_pair" {
  type    = string
  default = ""
}

variable "admin_pass" {
  type      = string
  default   = ""
  sensitive = true
}

variable "user_data" {
  type    = string
  default = ""
}

variable "public_eip_bandwidth_size" {
  type    = number
  default = 20
}

variable "public_eip_bandwidth_charge_mode" {
  type    = string
  default = "traffic"
}

variable "metadata" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}