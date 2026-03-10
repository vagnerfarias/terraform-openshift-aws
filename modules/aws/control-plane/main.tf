locals {
  common_tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.infrastructure_name}" = "owned"
    }
  )

  master_ignition = jsonencode({
    ignition = {
      version = "3.2.0"
      config = {
        replace = {
          source = var.master_ignition_url
        }
      }
    }
  })
}

resource "aws_instance" "master" {
  count = var.instance_count

  ami                    = var.rhcos_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.instance_profile_name

  user_data = local.master_ignition

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.infrastructure_name}-master-${count.index}"
      Role = "master"
    }
  )
}

resource "aws_lb_target_group_attachment" "external_api" {
  count = var.instance_count

  target_group_arn = var.external_api_target_group_arn
  target_id        = aws_instance.master[count.index].private_ip
  port             = 6443
}

resource "aws_lb_target_group_attachment" "internal_api" {
  count = var.instance_count

  target_group_arn = var.internal_api_target_group_arn
  target_id        = aws_instance.master[count.index].private_ip
  port             = 6443
}

resource "aws_lb_target_group_attachment" "internal_service" {
  count = var.instance_count

  target_group_arn = var.internal_service_target_group_arn
  target_id        = aws_instance.master[count.index].private_ip
  port             = 22623
}