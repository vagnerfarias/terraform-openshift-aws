variable "cluster_name" {
  type        = string
  description = "Must match install-config.yaml (metadata and DNS names)."
}

variable "base_domain" {
  type        = string
  description = "Public base domain hosted zone (e.g. example.com)"
}

variable "public_dns_zone_id" {
  type        = string
  description = "Route53 public hosted zone ID for base_domain."
}

variable "cloud_region" {
  type        = string
  description = "AWS region (e.g. us-east-2)."
}

# Dynamic (from Ansible playbook)
variable "infrastructure_name" {
  type        = string
  description = "OpenShift infraID from metadata.json"
  default     = ""
}

variable "ignition_bucket" {
  type        = string
  description = "S3 bucket containing ignition files"
  default     = ""
}

variable "ignition_prefix" {
  type        = string
  description = "S3 prefix (folder) where ignitions live"
  default     = "ignition"
}

variable "rhcos_image_id" {
  type        = string
  description = "RHCOS image ID for the cluster version/region"
  default     = ""
}

variable "bootstrap_ignition_url" {
  type        = string
  description = "Pre-signed URL for bootstrap.ign"
  default     = ""
}

variable "master_ignition_url" {
  type        = string
  description = "Pre-signed URL for master.ign"
  default     = ""
}

variable "worker_ignition_url" {
  type        = string
  description = "Pre-signed URL for worker.ign"
  default     = ""
}