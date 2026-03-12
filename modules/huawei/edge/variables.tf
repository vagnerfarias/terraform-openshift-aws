variable "cluster_name" {
  type        = string
  description = "OpenShift cluster name."
}

variable "base_domain" {
  type        = string
  description = "Base DNS domain."
}

variable "infrastructure_name" {
  type        = string
  description = "Infrastructure prefix."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs."
}

variable "manage_public_dns" {
  type        = bool
  description = "Whether to manage public DNS records."
  default     = true
}

variable "public_dns_zone_id" {
  type        = string
  description = "Existing public DNS zone ID."
  default     = ""
}

variable "manage_private_dns" {
  type        = bool
  description = "Whether to manage private DNS."
  default     = true
}

variable "private_dns_zone_id" {
  type        = string
  description = "Existing private DNS zone ID. If empty and manage_private_dns=true, a private zone is created."
  default     = ""
}

variable "public_dns_ttl" {
  type        = number
  description = "TTL for public DNS records."
  default     = 300
}

variable "private_dns_ttl" {
  type        = number
  description = "TTL for private DNS records."
  default     = 300
}

variable "public_eip_bandwidth_size" {
  type        = number
  description = "Bandwidth size in Mbit/s for each public ELB EIP."
  default     = 100
}

variable "public_eip_bandwidth_charge_mode" {
  type        = string
  description = "Bandwidth charge mode for each public ELB EIP."
  default     = "traffic"
}

variable "api_listener_port" {
  type        = number
  description = "Public API listener port."
  default     = 6443
}

variable "api_private_listener_port" {
  type        = number
  description = "Private API listener port."
  default     = 6443
}

variable "mcs_listener_port" {
  type        = number
  description = "Machine Config Server listener port."
  default     = 22623
}

variable "apps_http_listener_port" {
  type        = number
  description = "Ingress HTTP listener port."
  default     = 80
}

variable "apps_https_listener_port" {
  type        = number
  description = "Ingress HTTPS listener port."
  default     = 443
}

variable "apps_healthcheck_port" {
  type        = number
  description = "Ingress router health check port."
  default     = 1936
}

variable "apps_healthcheck_path" {
  type        = string
  description = "Ingress router health check path."
  default     = "/healthz"
}

variable "api_monitor_delay" {
  type        = number
  default     = 5
}

variable "api_monitor_timeout" {
  type        = number
  default     = 3
}

variable "api_monitor_retries" {
  type        = number
  default     = 3
}

variable "apps_monitor_delay" {
  type        = number
  default     = 5
}

variable "apps_monitor_timeout" {
  type        = number
  default     = 3
}

variable "apps_monitor_retries" {
  type        = number
  default     = 3
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}