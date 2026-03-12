# PORTING_NOTES.md

## Porting Terraform OpenShift UPI from AWS to Huawei Cloud

This document explains the architectural differences and implementation decisions made while porting the Terraform-based OpenShift UPI installation from **AWS** to **Huawei Cloud**.

The goal of this port is **functional equivalence**, not provider feature parity.
Huawei Cloud does not have a native OpenShift platform integration comparable to AWS, so **all infrastructure components must be created explicitly via Terraform**.

---

# 1. General Architecture

The original repository targets **AWS UPI (platform: none)** and creates all infrastructure manually.

The Huawei Cloud implementation follows the **same layered structure**:

```
live/<provider>/<env>/
    00-config
    01-network
    02-edge
    03-security
    04-bootstrap
    05-control-plane
    06-compute
    02-bastion
```

Modules are organized under:

```
modules/
    aws/
    huawei/
```

This keeps provider implementations isolated while preserving the same logical architecture.

---

# 2. Key Differences Between AWS and Huawei Cloud

## 2.1 Compute Instances

AWS:

```
aws_instance
```

Huawei Cloud:

```
huaweicloud_compute_instance
```

Important differences:

| Concept         | AWS                    | Huawei                              |
| --------------- | ---------------------- | ----------------------------------- |
| Image           | AMI                    | Image ID                            |
| Instance type   | instance_type          | flavor_id                           |
| Network         | subnet_id              | network { uuid = subnet_id }        |
| Security groups | vpc_security_group_ids | security_groups                     |
| Disk            | root_block_device      | system_disk_type / system_disk_size |

Potential attribute differences:

The private IP attribute returned by the instance resource **may vary depending on provider version**.

Examples:

```
access_ip_v4
private_ip
network[0].fixed_ip_v4
```

This affects:

* control-plane module
* compute module
* bootstrap module
* bastion module

---

# 3. Load Balancer Architecture

## AWS Implementation

AWS used **Network Load Balancers (NLB)**.

Key components:

```
aws_lb
aws_lb_target_group
aws_lb_listener
aws_lb_target_group_attachment
```

Characteristics:

* L4 load balancing
* targets registered by instance ID or IP
* AWS manages backend networking automatically

---

## Huawei Cloud Implementation

Huawei Cloud uses **Elastic Load Balancer (ELB)**.

Terraform resources:

```
huaweicloud_lb_loadbalancer
huaweicloud_lb_listener
huaweicloud_lb_pool
huaweicloud_lb_member
huaweicloud_lb_monitor
```

Backend members must be registered using:

```
address (private IP)
subnet_id
protocol_port
```

Unlike AWS, Huawei ELB **requires explicit backend subnet information**.

---

# 4. Dedicated vs Shared ELB

Huawei Cloud provides two types:

| Type      | Description          |
| --------- | -------------------- |
| Shared    | multi-tenant LB      |
| Dedicated | isolated LB instance |

This repository **uses only Dedicated ELB**.

Reasons:

* predictable networking
* backend subnet control
* simpler security group rules
* closer mapping to AWS NLB behavior

The ELB subnet CIDRs are exported and used by the `security` module.

---

# 5. Security Groups

AWS:

```
aws_security_group
```

Huawei:

```
huaweicloud_networking_secgroup
huaweicloud_networking_secgroup_rule
```

Important difference:

Huawei requires **explicit rule priority**.

Example:

```
priority = 100
```

Rules must also specify:

```
direction = ingress | egress
ethertype = IPv4
```

---

# 6. DNS

AWS uses:

```
Route53
```

Resources:

```
aws_route53_record
```

Huawei Cloud uses:

```
huaweicloud_dns_zone
huaweicloud_dns_recordset
```

DNS zones can be:

* public
* private

Private zones must be **associated with the VPC**.

---

# 7. Elastic IPs

AWS:

Public IP is directly associated with instances.

Huawei:

Public access requires **Elastic IP (EIP)** resources.

Terraform resources:

```
huaweicloud_vpc_eip
huaweicloud_compute_eip_associate
```

This is used for:

* bastion host
* public load balancers

---

# 8. Bootstrap Lifecycle

OpenShift UPI requires the bootstrap node to exist temporarily.

Bootstrap responsibilities:

* temporary API endpoint
* temporary Machine Config Server

Lifecycle:

1. bootstrap instance created
2. masters join
3. bootstrap completes
4. bootstrap node removed

In this repository:

```
live/huawei/dev/04-bootstrap
```

can simply be destroyed after installation.

---

# 9. Ignition Injection

AWS and Huawei both support instance user-data.

Ignition is injected as:

```
user_data = base64encode(...)
```

The user data contains an Ignition configuration referencing the full Ignition file URL.

Example:

```
{
  ignition: {
    version: "3.2.0",
    config: {
      replace: {
        source: "<ignition-url>"
      }
    }
  }
}
```

---

# 10. Networking Model

AWS networking:

```
VPC
Subnets
Route tables
Internet Gateway
```

Huawei Cloud networking:

```
VPC
Subnets
EIP
ELB
```

Routing is simpler but requires explicit EIP configuration.

---

# 11. Terraform State Design

Each layer uses independent state files:

```
00-config
01-network
02-edge
03-security
04-bootstrap
05-control-plane
06-compute
```

Modules communicate via:

```
terraform_remote_state
```

This preserves the same structure used in the AWS implementation.

---

# 12. Known Areas That May Require Adjustment

These areas are provider-version dependent and may require small changes:

### ECS Instance attributes

Private IP attribute name.

### ELB Member schema

Attributes required by `huaweicloud_lb_member`.

### ECS user_data behavior

Some versions require base64 encoding, others handle it automatically.

### Disk configuration

Some providers require block syntax instead of flat parameters.

---

# 13. Installation Order

Recommended Terraform apply sequence:

```
00-config
01-network
02-edge
03-security
04-bootstrap
05-control-plane
06-compute
```

After installation completes:

```
terraform destroy live/huawei/dev/04-bootstrap
```

---

# 14. Future Improvements

Possible improvements for the Huawei implementation:

* optional support for **Shared ELB**
* automated **bootstrap removal**
* instance groups / autoscaling
* better **Ignition hosting automation**
* dynamic RHCOS image discovery
* improved **flavor validation**

---

# 15. Disclaimer

Huawei Cloud is **not an officially supported OpenShift installation platform**.

This implementation provides an **experimental UPI deployment** using Terraform and manual infrastructure provisioning.

It should be treated as a reference implementation rather than production-ready automation.
