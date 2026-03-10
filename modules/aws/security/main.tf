locals {
  common_tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.infrastructure_name}" = "owned"
    }
  )
}

resource "aws_security_group" "master" {
  name        = "${var.infrastructure_name}-master-sg"
  description = "Cluster Master Security Group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "icmp"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.vpc_cidr]
    description = "ICMP from VPC"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.vpc_cidr]
    description = "SSH from VPC"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = [var.vpc_cidr]
    description = "API from VPC"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22623
    to_port     = 22623
    cidr_blocks = [var.vpc_cidr]
    description = "MCS from VPC"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.infrastructure_name}-master-sg"
  })
}

resource "aws_security_group" "worker" {
  name        = "${var.infrastructure_name}-worker-sg"
  description = "Cluster Worker Security Group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "icmp"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.vpc_cidr]
    description = "ICMP from VPC"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.vpc_cidr]
    description = "SSH from VPC"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.infrastructure_name}-worker-sg"
  })
}

locals {
  sg_pairs = {
    master_from_master = {
      target = aws_security_group.master.id
      source = aws_security_group.master.id
    }
    master_from_worker = {
      target = aws_security_group.master.id
      source = aws_security_group.worker.id
    }
    worker_from_worker = {
      target = aws_security_group.worker.id
      source = aws_security_group.worker.id
    }
    worker_from_master = {
      target = aws_security_group.worker.id
      source = aws_security_group.master.id
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "master_etcd" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 2379
  to_port                      = 2380
  description                  = "etcd"
}

resource "aws_vpc_security_group_ingress_rule" "master_vxlan_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 4789
  to_port                      = 4789
  description                  = "Vxlan packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_vxlan_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 4789
  to_port                      = 4789
  description                  = "Vxlan packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_geneve_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 6081
  to_port                      = 6081
  description                  = "Geneve packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_geneve_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 6081
  to_port                      = 6081
  description                  = "Geneve packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsec_ike_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 500
  to_port                      = 500
  description                  = "IPsec IKE packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsec_ike_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 500
  to_port                      = 500
  description                  = "IPsec IKE packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsec_nat_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 4500
  to_port                      = 4500
  description                  = "IPsec NAT-T packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsec_nat_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 4500
  to_port                      = 4500
  description                  = "IPsec NAT-T packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsec_esp_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "50"
  description                  = "IPsec ESP packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsec_esp_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "50"
  description                  = "IPsec ESP packets"
}

resource "aws_vpc_security_group_ingress_rule" "master_internal_tcp_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 9000
  to_port                      = 9999
  description                  = "Internal cluster communication"
}

resource "aws_vpc_security_group_ingress_rule" "master_internal_tcp_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 9000
  to_port                      = 9999
  description                  = "Internal cluster communication"
}

resource "aws_vpc_security_group_ingress_rule" "master_internal_udp_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 9000
  to_port                      = 9999
  description                  = "Internal cluster communication"
}

resource "aws_vpc_security_group_ingress_rule" "master_internal_udp_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 9000
  to_port                      = 9999
  description                  = "Internal cluster communication"
}

resource "aws_vpc_security_group_ingress_rule" "master_kube_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10259
  description                  = "Kubernetes kubelet, scheduler and controller manager"
}

resource "aws_vpc_security_group_ingress_rule" "master_kube_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10259
  description                  = "Kubernetes kubelet, scheduler and controller manager"
}

resource "aws_vpc_security_group_ingress_rule" "master_ingress_tcp_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "Kubernetes ingress services"
}

resource "aws_vpc_security_group_ingress_rule" "master_ingress_tcp_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "Kubernetes ingress services"
}

resource "aws_vpc_security_group_ingress_rule" "master_ingress_udp_master" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "Kubernetes ingress services"
}

resource "aws_vpc_security_group_ingress_rule" "master_ingress_udp_worker" {
  security_group_id            = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "Kubernetes ingress services"
}

resource "aws_vpc_security_group_ingress_rule" "worker_vxlan_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 4789
  to_port                      = 4789
  description                  = "Vxlan packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_vxlan_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 4789
  to_port                      = 4789
  description                  = "Vxlan packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_geneve_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 6081
  to_port                      = 6081
  description                  = "Geneve packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_geneve_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 6081
  to_port                      = 6081
  description                  = "Geneve packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsec_ike_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 500
  to_port                      = 500
  description                  = "IPsec IKE packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsec_ike_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 500
  to_port                      = 500
  description                  = "IPsec IKE packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsec_nat_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 4500
  to_port                      = 4500
  description                  = "IPsec NAT-T packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsec_nat_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 4500
  to_port                      = 4500
  description                  = "IPsec NAT-T packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsec_esp_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "50"
  description                  = "IPsec ESP packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsec_esp_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "50"
  description                  = "IPsec ESP packets"
}

resource "aws_vpc_security_group_ingress_rule" "worker_internal_tcp_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 9000
  to_port                      = 9999
  description                  = "Internal cluster communication"
}

resource "aws_vpc_security_group_ingress_rule" "worker_internal_tcp_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 9000
  to_port                      = 9999
  description                  = "Internal cluster communication"
}

resource "aws_vpc_security_group_ingress_rule" "worker_internal_udp_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 9000
  to_port                      = 9999
  description                  = "Internal cluster communication"
}

resource "aws_vpc_security_group_ingress_rule" "worker_internal_udp_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 9000
  to_port                      = 9999
  description                  = "Internal cluster communication"
}

resource "aws_vpc_security_group_ingress_rule" "worker_kube_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10250
  description                  = "Kubernetes secure kubelet port"
}

resource "aws_vpc_security_group_ingress_rule" "worker_kube_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10250
  description                  = "Internal Kubernetes communication"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_tcp_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "Kubernetes ingress services"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_tcp_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "Kubernetes ingress services"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_udp_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "Kubernetes ingress services"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_udp_master" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "Kubernetes ingress services"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_http_public" {
  security_group_id = aws_security_group.worker.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Ingress HTTP from clients"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_https_public" {
  security_group_id = aws_security_group.worker.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Ingress HTTPS from clients"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_healthcheck" {
  security_group_id = aws_security_group.worker.id
  ip_protocol       = "tcp"
  from_port         = 1936
  to_port           = 1936
  cidr_ipv4         = var.vpc_cidr
  description       = "Ingress router health checks from within VPC"
}

resource "aws_iam_role" "master" {
  name = "${var.infrastructure_name}-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "${var.infrastructure_name}-master-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = [
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:Describe*",
          "ec2:DetachVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:RevokeSecurityGroupIngress",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:AttachLoadBalancerToSubnets",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancerListeners",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:DetachLoadBalancerFromSubnets",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }]
    })
  }

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "master" {
  name = "${var.infrastructure_name}-master-profile"
  role = aws_iam_role.master.name
  tags = local.common_tags
}

resource "aws_iam_role" "worker" {
  name = "${var.infrastructure_name}-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "${var.infrastructure_name}-worker-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions"
        ]
        Resource = "*"
      }]
    })
  }

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "worker" {
  name = "${var.infrastructure_name}-worker-profile"
  role = aws_iam_role.worker.name
  tags = local.common_tags
}