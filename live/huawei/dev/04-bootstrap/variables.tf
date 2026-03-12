variable "flavor_id" {
  type        = string
  description = "Huawei Cloud ECS flavor ID for the bootstrap node."
}

variable "system_disk_size" {
  type    = number
  default = 120
}

variable "system_disk_type" {
  type    = string
  default = "SSD"
}

variable "admin_pass" {
  type      = string
  default   = ""
  sensitive = true
}

variable "key_pair" {
  type    = string
  default = ""
}

variable "metadata" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}