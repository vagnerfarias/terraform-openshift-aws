variable "infrastructure_name" {
  type        = string
  description = "Infrastructure prefix."
}

variable "rhcos_image_id" {
  type        = string
  description = "RHCOS image ID available in Huawei Cloud."
}

variable "bootstrap_ignition_url" {
  type        = string
  description = "URL for bootstrap ignition."
}

variable "subnet_id" {
  type        = string
  description = "Private subnet ID used by the bootstrap node."
}

variable "availability_zone" {
  type        = string
  description = "Availability zone used by the bootstrap node."
}

variable "control_plane_security_group_id" {
  type        = string
  description = "Security group ID used by the bootstrap node."
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

variable "flavor_id" {
  type        = string
  description = "Huawei Cloud ECS flavor ID for the bootstrap node."
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