locals {
  cluster_zone_fqdn = "${var.cluster_name}.${var.base_domain}."
  api_fqdn          = "api.${var.cluster_name}.${var.base_domain}."
  api_int_fqdn      = "api-int.${var.cluster_name}.${var.base_domain}."
  apps_wildcard_fqdn = "*.apps.${var.cluster_name}.${var.base_domain}."

  public_subnet_id  = var.public_subnet_ids[0]
  private_subnet_id = var.private_subnet_ids[0]

  public_subnet_cidr  = var.public_subnet_cidrs[0]
  private_subnet_cidr = var.private_subnet_cidrs[0]

  private_zone_id = (
    var.manage_private_dns
      ? (
          var.private_dns_zone_id != ""
          ? var.private_dns_zone_id
          : huaweicloud_dns_zone.private[0].id
        )
      : null
  )
}

#
# Public API load balancer (6443)
#

resource "huaweicloud_lb_loadbalancer" "api_public" {
  name         = "${var.infrastructure_name}-api-public"
  description  = "Public API load balancer"
  vip_subnet_id = local.public_subnet_id
  tags         = var.tags
}

resource "huaweicloud_vpc_eip" "api_public" {
  name = "${var.infrastructure_name}-api-public-eip"

  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "${var.infrastructure_name}-api-public-bw"
    size        = var.public_eip_bandwidth_size
    charge_mode = var.public_eip_bandwidth_charge_mode
  }

  tags = var.tags
}

resource "huaweicloud_vpc_eip_associate" "api_public" {
  public_ip = huaweicloud_vpc_eip.api_public.address
  port_id   = huaweicloud_lb_loadbalancer.api_public.vip_port_id
}

resource "huaweicloud_lb_listener" "api_public" {
  name            = "${var.infrastructure_name}-api-public"
  protocol        = "TCP"
  protocol_port   = var.api_listener_port
  loadbalancer_id = huaweicloud_lb_loadbalancer.api_public.id
  tags            = var.tags
}

resource "huaweicloud_lb_pool" "api_public" {
  name        = "${var.infrastructure_name}-api-public"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = huaweicloud_lb_listener.api_public.id
}

resource "huaweicloud_lb_monitor" "api_public" {
  pool_id     = huaweicloud_lb_pool.api_public.id
  type        = "TCP"
  delay       = var.api_monitor_delay
  timeout     = var.api_monitor_timeout
  max_retries = var.api_monitor_retries
}

#
# Private API load balancer (6443 + 22623)
#

resource "huaweicloud_lb_loadbalancer" "api_private" {
  name         = "${var.infrastructure_name}-api-private"
  description  = "Private API and MCS load balancer"
  vip_subnet_id = local.private_subnet_id
  tags         = var.tags
}

resource "huaweicloud_lb_listener" "api_private" {
  name            = "${var.infrastructure_name}-api-private"
  protocol        = "TCP"
  protocol_port   = var.api_private_listener_port
  loadbalancer_id = huaweicloud_lb_loadbalancer.api_private.id
  tags            = var.tags
}

resource "huaweicloud_lb_pool" "api_private" {
  name        = "${var.infrastructure_name}-api-private"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = huaweicloud_lb_listener.api_private.id
}

resource "huaweicloud_lb_monitor" "api_private" {
  pool_id     = huaweicloud_lb_pool.api_private.id
  type        = "TCP"
  delay       = var.api_monitor_delay
  timeout     = var.api_monitor_timeout
  max_retries = var.api_monitor_retries
}

resource "huaweicloud_lb_listener" "mcs_private" {
  name            = "${var.infrastructure_name}-mcs-private"
  protocol        = "TCP"
  protocol_port   = var.mcs_listener_port
  loadbalancer_id = huaweicloud_lb_loadbalancer.api_private.id
  tags            = var.tags
}

resource "huaweicloud_lb_pool" "mcs_private" {
  name        = "${var.infrastructure_name}-mcs-private"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = huaweicloud_lb_listener.mcs_private.id
}

resource "huaweicloud_lb_monitor" "mcs_private" {
  pool_id     = huaweicloud_lb_pool.mcs_private.id
  type        = "TCP"
  delay       = var.api_monitor_delay
  timeout     = var.api_monitor_timeout
  max_retries = var.api_monitor_retries
}

#
# Public apps load balancer (80 + 443)
#

resource "huaweicloud_lb_loadbalancer" "apps_public" {
  name         = "${var.infrastructure_name}-apps-public"
  description  = "Public apps load balancer"
  vip_subnet_id = local.public_subnet_id
  tags         = var.tags
}

resource "huaweicloud_vpc_eip" "apps_public" {
  name = "${var.infrastructure_name}-apps-public-eip"

  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "${var.infrastructure_name}-apps-public-bw"
    size        = var.public_eip_bandwidth_size
    charge_mode = var.public_eip_bandwidth_charge_mode
  }

  tags = var.tags
}

resource "huaweicloud_vpc_eip_associate" "apps_public" {
  public_ip = huaweicloud_vpc_eip.apps_public.address
  port_id   = huaweicloud_lb_loadbalancer.apps_public.vip_port_id
}

resource "huaweicloud_lb_listener" "apps_http" {
  name            = "${var.infrastructure_name}-apps-http"
  protocol        = "TCP"
  protocol_port   = var.apps_http_listener_port
  loadbalancer_id = huaweicloud_lb_loadbalancer.apps_public.id
  tags            = var.tags
}

resource "huaweicloud_lb_pool" "apps_http" {
  name        = "${var.infrastructure_name}-apps-http"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = huaweicloud_lb_listener.apps_http.id
}

resource "huaweicloud_lb_monitor" "apps_http" {
  pool_id         = huaweicloud_lb_pool.apps_http.id
  type            = "HTTP"
  port            = var.apps_healthcheck_port
  url_path        = var.apps_healthcheck_path
  http_method     = "GET"
  expected_codes  = "200"
  delay           = var.apps_monitor_delay
  timeout         = var.apps_monitor_timeout
  max_retries     = var.apps_monitor_retries
}

resource "huaweicloud_lb_listener" "apps_https" {
  name            = "${var.infrastructure_name}-apps-https"
  protocol        = "TCP"
  protocol_port   = var.apps_https_listener_port
  loadbalancer_id = huaweicloud_lb_loadbalancer.apps_public.id
  tags            = var.tags
}

resource "huaweicloud_lb_pool" "apps_https" {
  name        = "${var.infrastructure_name}-apps-https"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = huaweicloud_lb_listener.apps_https.id
}

resource "huaweicloud_lb_monitor" "apps_https" {
  pool_id         = huaweicloud_lb_pool.apps_https.id
  type            = "HTTP"
  port            = var.apps_healthcheck_port
  url_path        = var.apps_healthcheck_path
  http_method     = "GET"
  expected_codes  = "200"
  delay           = var.apps_monitor_delay
  timeout         = var.apps_monitor_timeout
  max_retries     = var.apps_monitor_retries
}

#
# Private DNS zone (optional)
#

resource "huaweicloud_dns_zone" "private" {
  count = var.manage_private_dns && var.private_dns_zone_id == "" ? 1 : 0

  name      = local.cluster_zone_fqdn
  zone_type = "private"
  ttl       = var.private_dns_ttl

  router {
    router_id = var.vpc_id
  }

  tags = var.tags
}

#
# Public DNS records (optional)
#

resource "huaweicloud_dns_recordset" "public_api" {
  count = var.manage_public_dns && var.public_dns_zone_id != "" ? 1 : 0

  zone_id = var.public_dns_zone_id
  name    = local.api_fqdn
  type    = "A"
  ttl     = var.public_dns_ttl
  records = [huaweicloud_vpc_eip.api_public.address]
  status  = "ENABLE"
  tags    = var.tags

  depends_on = [huaweicloud_vpc_eip_associate.api_public]
}

resource "huaweicloud_dns_recordset" "public_apps" {
  count = var.manage_public_dns && var.public_dns_zone_id != "" ? 1 : 0

  zone_id = var.public_dns_zone_id
  name    = local.apps_wildcard_fqdn
  type    = "A"
  ttl     = var.public_dns_ttl
  records = [huaweicloud_vpc_eip.apps_public.address]
  status  = "ENABLE"
  tags    = var.tags

  depends_on = [huaweicloud_vpc_eip_associate.apps_public]
}

#
# Private DNS records (optional)
#

resource "huaweicloud_dns_recordset" "private_api" {
  count = var.manage_private_dns ? 1 : 0

  zone_id = local.private_zone_id
  name    = local.api_fqdn
  type    = "A"
  ttl     = var.private_dns_ttl
  records = [huaweicloud_lb_loadbalancer.api_private.vip_address]
  status  = "ENABLE"
  tags    = var.tags
}

resource "huaweicloud_dns_recordset" "private_api_int" {
  count = var.manage_private_dns ? 1 : 0

  zone_id = local.private_zone_id
  name    = local.api_int_fqdn
  type    = "A"
  ttl     = var.private_dns_ttl
  records = [huaweicloud_lb_loadbalancer.api_private.vip_address]
  status  = "ENABLE"
  tags    = var.tags
}