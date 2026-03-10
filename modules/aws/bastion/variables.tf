variable "name" {
  type        = string
  description = "Name prefix for bastion resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the bastion security group will be created."
}

variable "subnet_id" {
  type        = string
  description = "Public subnet ID where the bastion instance will be launched."
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Allowed source CIDR for SSH access."
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Bastion instance type."
}

variable "root_volume_gb" {
  type        = number
  default     = 40
  description = "Root volume size (GiB)."
}

variable "image_id" {
  type        = string
  default     = ""
  description = "Optional Fedora image ID. If empty, Terraform tries to discover one automatically."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags."
}

variable "key_name" {
  type        = string
  description = "EC2 Key Pair name."
}

variable "public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to SSH public key."
}

variable "manage_key_pair" {
  type        = bool
  default     = true
  description = "If true, Terraform will create/import the EC2 Key Pair from public_key_path."
}