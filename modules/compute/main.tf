locals {
  common_tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.infrastructure_name}" = "owned"
    }
  )

  worker_ignition = jsonencode({
    ignition = {
      version = "3.2.0"
      config = {
        replace = {
          source = var.worker_ignition_url
        }
      }
    }
  })
}

resource "aws_instance" "worker" {
  count = var.instance_count

  ami                    = var.rhcos_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.instance_profile_name

  user_data = local.worker_ignition

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
      Name = "${var.infrastructure_name}-worker-${count.index}"
      Role = "worker"
    }
  )
}

resource "aws_lb_target_group_attachment" "apps_http" {
  count = var.apps_http_target_group_arn != "" ? var.instance_count : 0

  target_group_arn = var.apps_http_target_group_arn
  target_id        = aws_instance.worker[count.index].private_ip
  port             = 80
}

resource "aws_lb_target_group_attachment" "apps_https" {
  count = var.apps_https_target_group_arn != "" ? var.instance_count : 0

  target_group_arn = var.apps_https_target_group_arn
  target_id        = aws_instance.worker[count.index].private_ip
  port             = 443
}