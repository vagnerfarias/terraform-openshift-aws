variable "cluster_name" {
  type        = string
  description = "OpenShift cluster name."
}

variable "base_domain" {
  type        = string
  description = "Base DNS domain for the cluster."
}

variable "cloud_region" {
  type        = string
  description = "Huawei Cloud region."
}

variable "infrastructure_name" {
  type        = string
  description = "Infrastructure ID used as prefix for created resources."
}

variable "rhcos_image_id" {
  type        = string
  description = "RHCOS image ID available in Huawei Cloud."
}

variable "bootstrap_ignition_url" {
  type        = string
  description = "URL for bootstrap ignition."
}

variable "master_ignition_url" {
  type        = string
  description = "URL for master ignition."
}

variable "worker_ignition_url" {
  type        = string
  description = "URL for worker ignition."
}

variable "public_dns_zone_name" {
  type        = string
  description = "Public DNS zone name managed externally or in Huawei DNS."
}

variable "public_dns_zone_id" {
  type        = string
  description = "Public DNS zone ID, when managed by provider DNS."
  default     = ""
}