locals {
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids

  ssh_user = "fedora"

  common_tags = merge(
    {
      Project = "ocp-aws-non-integrated"
      Env     = "dev"
      Name    = "ocp-bastion"
    },
    var.tags
  )
}

# Try to discover Fedora AMI automatically (works when official/public images are visible in your account/region).
# Fedora images are commonly distributed via AWS Marketplace / "Sold by AWS" listings. :contentReference[oaicite:0]{index=0}
data "aws_ami" "fedora" {
  count       = var.ami_id == "" ? 1 : 0
  most_recent = true

  # NOTE: The exact owner for Fedora images can vary depending on how you consume them (Marketplace / community account).
  # If this lookup fails in your account, set var.ami_id explicitly.
  owners = ["125523088429"] # often cited as the "Sold by AWS" owner for Fedora Marketplace images :contentReference[oaicite:1]{index=1}

  filter {
    name   = "name"
    values = ["Fedora-Cloud-Base-*-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  selected_ami = var.ami_id != "" ? var.ami_id : data.aws_ami.fedora[0].id
}

resource "aws_security_group" "bastion" {
  name        = "ocp-bastion-sg"
  description = "Bastion SG: SSH only from my public IP"
  vpc_id      = local.vpc_id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_instance" "bastion" {
  ami                         = local.selected_ami
  instance_type               = var.instance_type
  subnet_id                   = local.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name = var.manage_key_pair ? aws_key_pair.bastion[0].key_name : var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.root_volume_gb
    volume_type = "gp3"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = local.common_tags
}

resource "aws_key_pair" "bastion" {
  count      = var.manage_key_pair ? 1 : 0
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))

  tags = merge(var.tags, {
    Name = var.key_name
  })
}