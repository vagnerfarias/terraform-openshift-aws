locals {
  # NLB name limit is 32 chars. Keep it safe.
  # We'll base on infra name and suffix.
  ext_lb_name = substr(replace("${var.infrastructure_name}-ext", "/[^a-zA-Z0-9-]/", "-"), 0, 32)
  int_lb_name = substr(replace("${var.infrastructure_name}-int", "/[^a-zA-Z0-9-]/", "-"), 0, 32)

  fqdn_api     = "api.${var.cluster_name}.${var.base_domain}"
  fqdn_api_int = "api-int.${var.cluster_name}.${var.base_domain}"

  common_tags = merge(var.tags, {
    "kubernetes.io/cluster/${var.infrastructure_name}" = "owned"
  })
}

# --- NLBs ---
resource "aws_lb" "ext_api" {
  name               = local.ext_lb_name
  load_balancer_type = "network"
  internal           = false
  subnets            = var.public_subnet_ids

  tags = merge(local.common_tags, { Name = local.ext_lb_name })
}

resource "aws_lb" "int_api" {
  name               = local.int_lb_name
  load_balancer_type = "network"
  internal           = true
  subnets            = var.private_subnet_ids

  tags = merge(local.common_tags, { Name = local.int_lb_name })
}

# --- Target Groups (target_type = ip, like CFN) ---
resource "aws_lb_target_group" "ext_api_6443" {
  name        = substr(replace("${var.infrastructure_name}-ext-6443", "/[^a-zA-Z0-9-]/", "-"), 0, 32)
  port        = 6443
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTPS"
    port                = "6443"
    path                = "/readyz"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.common_tags
}

resource "aws_lb_target_group" "int_api_6443" {
  name        = substr(replace("${var.infrastructure_name}-int-6443", "/[^a-zA-Z0-9-]/", "-"), 0, 32)
  port        = 6443
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTPS"
    port                = "6443"
    path                = "/readyz"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.common_tags
}

resource "aws_lb_target_group" "int_svc_22623" {
  name        = substr(replace("${var.infrastructure_name}-int-22623", "/[^a-zA-Z0-9-]/", "-"), 0, 32)
  port        = 22623
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTPS"
    port                = "22623"
    path                = "/healthz"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.common_tags
}

# --- Listeners ---
resource "aws_lb_listener" "ext_6443" {
  load_balancer_arn = aws_lb.ext_api.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ext_api_6443.arn
  }
}

resource "aws_lb_listener" "int_6443" {
  load_balancer_arn = aws_lb.int_api.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.int_api_6443.arn
  }
}

resource "aws_lb_listener" "int_22623" {
  load_balancer_arn = aws_lb.int_api.arn
  port              = 22623
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.int_svc_22623.arn
  }
}

# --- Private hosted zone: <cluster>.<base_domain> associated to VPC ---
resource "aws_route53_zone" "private_cluster_zone" {
  name = "${var.cluster_name}.${var.base_domain}"

  vpc {
    vpc_id = var.vpc_id
  }

  comment = "Managed by Terraform (private cluster zone)"
  tags    = merge(local.common_tags, { Name = "${var.infrastructure_name}-int" })
}

# --- Public record: api.<cluster>.<base_domain> -> external NLB ---
resource "aws_route53_record" "public_api" {
  zone_id = var.public_dns_zone_id
  name    = local.fqdn_api
  type    = "A"

  alias {
    name                   = aws_lb.ext_api.dns_name
    zone_id                = aws_lb.ext_api.zone_id
    evaluate_target_health = false
  }
}

# --- Private records: api + api-int -> internal NLB ---
resource "aws_route53_record" "private_api" {
  zone_id = aws_route53_zone.private_cluster_zone.zone_id
  name    = local.fqdn_api
  type    = "A"

  alias {
    name                   = aws_lb.int_api.dns_name
    zone_id                = aws_lb.int_api.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private_api_int" {
  zone_id = aws_route53_zone.private_cluster_zone.zone_id
  name    = local.fqdn_api_int
  type    = "A"

  alias {
    name                   = aws_lb.int_api.dns_name
    zone_id                = aws_lb.int_api.zone_id
    evaluate_target_health = false
  }
}


# LB for ingress 
locals {
  apps_lb_name = substr(replace("${var.infrastructure_name}-apps", "/[^a-zA-Z0-9-]/", "-"), 0, 32)
}

resource "aws_lb" "apps" {
  name               = local.apps_lb_name
  load_balancer_type = "network"
  internal           = false
  subnets            = var.public_subnet_ids

  tags = merge(local.common_tags, {
    Name = local.apps_lb_name
  })
}

resource "aws_lb_target_group" "apps_http_80" {
  name        = substr(replace("${var.infrastructure_name}-apps-80", "/[^a-zA-Z0-9-]/", "-"), 0, 32)
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "1936"
    path                = "/healthz/ready"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = local.common_tags
}

resource "aws_lb_target_group" "apps_https_443" {
  name        = substr(replace("${var.infrastructure_name}-apps-443", "/[^a-zA-Z0-9-]/", "-"), 0, 32)
  port        = 443
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "1936"
    path                = "/healthz/ready"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "apps_80" {
  load_balancer_arn = aws_lb.apps.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apps_http_80.arn
  }
}

resource "aws_lb_listener" "apps_443" {
  load_balancer_arn = aws_lb.apps.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apps_https_443.arn
  }
}

resource "aws_route53_record" "public_apps_wildcard" {
  zone_id = var.public_dns_zone_id
  name    = "*.apps.${var.cluster_name}.${var.base_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.apps.dns_name
    zone_id                = aws_lb.apps.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "internal_apps_wildcard" {
  zone_id = aws_route53_zone.private_cluster_zone.zone_id
  name    = "*.apps.${var.cluster_name}.${var.base_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.apps.dns_name
    zone_id                = aws_lb.apps.zone_id
    evaluate_target_health = false
  }
}