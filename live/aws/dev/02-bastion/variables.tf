variable "allowed_ssh_cidr" {
  type        = string
  description = "Your public IP in CIDR notation, e.g. 203.0.113.10/32"
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

variable "image__id" {
  type        = string
  default     = ""
  description = "Optional: Fedora image ID. If empty, Terraform will try to discover the latest Fedora Cloud Base AMI."
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
  description = "Path to SSH public key (e.g. ~/.ssh/id_rsa.pub)."
  default     = "~/.ssh/id_rsa.pub"
}

variable "manage_key_pair" {
  type        = bool
  description = "If true, Terraform will create/import the EC2 Key Pair from public_key_path."
  default     = true
}