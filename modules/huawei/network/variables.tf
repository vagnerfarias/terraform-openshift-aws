variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC."
}

variable "availability_zone_count" {
  type        = number
  description = "Number of AZs to use."
  validation {
    condition     = var.availability_zone_count >= 1
    error_message = "availability_zone_count must be at least 1."
  }
}

variable "subnet_bits" {
  type        = number
  description = "Subnet bits used with cidrsubnet()."
}

variable "vpc_name" {
  type        = string
  description = "Name prefix for the VPC and related resources."
}

variable "nat_gateway_spec" {
  type        = string
  description = "Huawei NAT Gateway spec: 1=small, 2=medium, 3=large, 4=extra-large."
  default     = "1"
  validation {
    condition     = contains(["1", "2", "3", "4"], var.nat_gateway_spec)
    error_message = "nat_gateway_spec must be one of: 1, 2, 3, 4."
  }
}

variable "nat_eip_bandwidth_size" {
  type        = number
  description = "Bandwidth size in Mbit/s for the NAT EIP."
  default     = 100
}

variable "nat_eip_bandwidth_charge_mode" {
  type        = string
  description = "Bandwidth charge mode for the NAT EIP: traffic or bandwidth."
  default     = "traffic"
  validation {
    condition     = contains(["traffic", "bandwidth"], var.nat_eip_bandwidth_charge_mode)
    error_message = "nat_eip_bandwidth_charge_mode must be either traffic or bandwidth."
  }
}

variable "primary_dns" {
  type        = string
  description = "Optional primary DNS server for subnets."
  default     = null
}

variable "secondary_dns" {
  type        = string
  description = "Optional secondary DNS server for subnets."
  default     = null
}

variable "dns_list" {
  type        = list(string)
  description = "Optional DNS server list for subnets."
  default     = null
}

variable "dhcp_enable" {
  type        = bool
  description = "Whether DHCP is enabled on subnets."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply where supported."
  default     = {}
}