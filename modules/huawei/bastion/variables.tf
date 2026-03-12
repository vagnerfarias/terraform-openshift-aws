variable "name" {
  type        = string
  description = "Name of the bastion instance."
}

variable "image_id" {
  type        = string
  description = "Image ID for the bastion instance."
}

variable "flavor_id" {
  type        = string
  description = "Huawei Cloud ECS flavor ID for the bastion instance."
}

variable "subnet_id" {
  type        = string
  description = "Public subnet ID where the bastion instance will be created."
}

variable "bastion_security_group_id" {
  type        = string
  description = "Security group ID for the bastion instance."
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the bastion instance."
}

variable "system_disk_size" {
  type        = number
  description = "System disk size in GiB."
  default     = 40
}

variable "system_disk_type" {
  type        = string
  description = "System disk type."
  default     = "SSD"
}

variable "key_pair" {
  type        = string
  description = "Optional key pair name."
  default     = ""
}

variable "admin_pass" {
  type        = string
  description = "Optional admin password."
  default     = ""
  sensitive   = true
}

variable "user_data" {
  type        = string
  description = "Optional user data content. It will be base64-encoded by the module."
  default     = ""
}

variable "public_eip_bandwidth_size" {
  type        = number
  description = "Bandwidth size in Mbit/s for the bastion EIP."
  default     = 20
}

variable "public_eip_bandwidth_charge_mode" {
  type        = string
  description = "Bandwidth charge mode for the bastion EIP."
  default     = "traffic"
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