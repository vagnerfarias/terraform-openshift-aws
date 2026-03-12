variable "manage_public_dns" {
  type        = bool
  default     = true
  description = "Whether to manage public DNS records."
}

variable "manage_private_dns" {
  type        = bool
  default     = true
  description = "Whether to manage private DNS records."
}

variable "private_dns_zone_id" {
  type        = string
  default     = ""
  description = "Existing private DNS zone ID. If empty and manage_private_dns=true, create one."
}

variable "public_dns_ttl" {
  type        = number
  default     = 300
  description = "TTL for public DNS records."
}

variable "private_dns_ttl" {
  type        = number
  default     = 300
  description = "TTL for private DNS records."
}

variable "public_eip_bandwidth_size" {
  type        = number
  default     = 100
  description = "Bandwidth size in Mbit/s for public ELB EIPs."
}

variable "public_eip_bandwidth_charge_mode" {
  type        = string
  default     = "traffic"
  description = "Bandwidth charge mode for public ELB EIPs."
}

variable "api_listener_port" {
  type        = number
  default     = 6443
}

variable "api_private_listener_port" {
  type        = number
  default     = 6443
}

variable "mcs_listener_port" {
  type        = number
  default     = 22623
}

variable "apps_http_listener_port" {
  type        = number
  default     = 80
}

variable "apps_https_listener_port" {
  type        = number
  default     = 443
}

variable "apps_healthcheck_port" {
  type        = number
  default     = 1936
}

variable "apps_healthcheck_path" {
  type        = string
  default     = "/healthz"
}

variable "api_monitor_delay" {
  type    = number
  default = 5
}

variable "api_monitor_timeout" {
  type    = number
  default = 3
}

variable "api_monitor_retries" {
  type    = number
  default = 3
}

variable "apps_monitor_delay" {
  type    = number
  default = 5
}

variable "apps_monitor_timeout" {
  type    = number
  default = 3
}

variable "apps_monitor_retries" {
  type    = number
  default = 3
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags."
}