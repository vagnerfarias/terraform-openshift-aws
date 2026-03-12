variable "infrastructure_name" {
  type        = string
  description = "Infrastructure prefix."
}

variable "rhcos_image_id" {
  type        = string
  description = "RHCOS image ID available in Huawei Cloud."
}

variable "worker_ignition_url" {
  type        = string
  description = "URL for worker ignition."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs used by worker nodes."
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones used to spread worker nodes."
}

variable "worker_security_group_id" {
  type        = string
  description = "Security group ID for worker nodes."
}

variable "apps_http_pool_id" {
  type        = string
  description = "Ingress HTTP pool ID."
}

variable "apps_https_pool_id" {
  type        = string
  description = "Ingress HTTPS pool ID."
}

variable "instance_count" {
  type        = number
  description = "Number of worker instances."
  default     = 2
}

variable "flavor_id" {
  type        = string
  description = "Huawei Cloud ECS flavor ID for worker nodes."
}

variable "system_disk_size" {
  type        = number
  description = "System disk size in GiB."
  default     = 120
}

variable "system_disk_type" {
  type        = string
  description = "System disk type."
  default     = "SSD"
}

variable "admin_pass" {
  type        = string
  description = "Optional admin password."
  default     = ""
  sensitive   = true
}

variable "key_pair" {
  type        = string
  description = "Optional key pair name."
  default     = ""
}

variable "metadata" {
  type        = map(string)
  description = "Optional ECS metadata."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}