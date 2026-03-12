variable "infrastructure_name" {
  type        = string
  description = "Infrastructure prefix."
}

variable "rhcos_image_id" {
  type        = string
  description = "RHCOS image ID available in Huawei Cloud."
}

variable "master_ignition_url" {
  type        = string
  description = "URL for master ignition."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs used by control plane nodes."
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones used to spread control plane nodes."
}

variable "control_plane_security_group_id" {
  type        = string
  description = "Security group ID for control plane nodes."
}

variable "api_public_pool_id" {
  type        = string
  description = "Public API pool ID."
}

variable "api_private_pool_id" {
  type        = string
  description = "Private API pool ID."
}

variable "mcs_private_pool_id" {
  type        = string
  description = "Private MCS pool ID."
}

variable "instance_count" {
  type        = number
  description = "Number of control plane instances."
  default     = 3
}

variable "flavor_id" {
  type        = string
  description = "Huawei Cloud ECS flavor ID for control plane nodes."
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
  description = "Optional admin password. Leave empty when using image/user-data based access only."
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