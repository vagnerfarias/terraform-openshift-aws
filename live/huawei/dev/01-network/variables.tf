variable "vpc_cidr" {
  type = string
}

variable "availability_zone_count" {
  type = number
}

variable "subnet_bits" {
  type = number
}

variable "nat_gateway_spec" {
  type    = string
  default = "1"
}

variable "nat_eip_bandwidth_size" {
  type    = number
  default = 100
}

variable "nat_eip_bandwidth_charge_mode" {
  type    = string
  default = "traffic"
}

variable "primary_dns" {
  type    = string
  default = null
}

variable "secondary_dns" {
  type    = string
  default = null
}

variable "dns_list" {
  type    = list(string)
  default = null
}

variable "dhcp_enable" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}