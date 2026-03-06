locals {
  common_tags = merge(
    var.tags,
    {
      "Name" = "${var.infrastructure_name}-bootstrap"
      "kubernetes.io/cluster/${var.infrastructure_name}" = "owned"
    }
  )

  bootstrap_ignition = jsonencode({
    ignition = {
      version = "3.2.0"
      config = {
        replace = {
          source = var.bootstrap_ignition_url
        }
      }
    }
  })
}

resource "aws_instance" "bootstrap" {
  ami                    = var.rhcos_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.instance_profile_name

  user_data = local.bootstrap_ignition

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = local.common_tags
}

resource "aws_lb_target_group_attachment" "external_api" {
  target_group_arn = var.external_api_target_group_arn
  target_id        = aws_instance.bootstrap.private_ip
  port             = 6443
}

resource "aws_lb_target_group_attachment" "internal_api" {
  target_group_arn = var.internal_api_target_group_arn
  target_id        = aws_instance.bootstrap.private_ip
  port             = 6443
}

resource "aws_lb_target_group_attachment" "internal_service" {
  target_group_arn = var.internal_service_target_group_arn
  target_id        = aws_instance.bootstrap.private_ip
  port             = 22623
}