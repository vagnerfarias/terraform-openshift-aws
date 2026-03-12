# TODO – Huawei Cloud Terraform Port (OpenShift UPI)

This file tracks implementation details that may require verification or adjustment during testing of the Huawei Cloud Terraform modules.

The current implementation is a first functional version intended to validate the architecture and provider behavior. Some attributes and provider behaviors may vary depending on the exact version of the Huawei Cloud Terraform provider.

---

## 1. Verify ECS Instance Resource Attributes

The modules currently use:

```
huaweicloud_compute_instance
```

Potential issues to verify:

* Confirm that this resource exists in the installed Huawei Cloud Terraform provider version.
* Verify that all required arguments are correct:

  * `image_id`
  * `flavor_id`
  * `availability_zone`
  * `security_groups`
  * `network { uuid = subnet_id }`
  * `system_disk_type`
  * `system_disk_size`
  * `user_data`

If errors occur, compare with the official provider documentation and adjust the resource schema accordingly.

---

## 2. Verify Private IP Attribute Used for ELB Backend Registration

ELB backend members require the **private IP address of the ECS instance**.

The modules currently use:

```
each.value.access_ip_v4
```

This attribute may vary depending on the provider version.

If Terraform errors occur, inspect the instance resource output and confirm the correct attribute, such as:

Possible alternatives:

* `access_ip_v4`
* `private_ip`
* `network[0].fixed_ip_v4`
* `network.0.fixed_ip_v4`

Update the following resources accordingly:

```
huaweicloud_lb_member
```

in:

* `modules/huawei/control-plane`
* `modules/huawei/compute`

---

## 3. Verify ELB Member Resource Compatibility

ELB members are currently defined using:

```
huaweicloud_lb_member
```

Key attributes to validate:

* `pool_id`
* `address`
* `subnet_id`
* `protocol_port`
* `weight`

If Terraform reports schema errors, verify the resource definition in the provider documentation and update the module accordingly.

---

## 4. Confirm ELB Backend Subnet Behavior

The design assumes **Dedicated ELB** behavior.

The following CIDRs are used in security rules:

* Public ELB backend subnet CIDR
* Private ELB backend subnet CIDR

These are passed from the `edge` module to the `security` module.

If health checks fail or traffic is blocked, verify that:

* The correct subnet CIDRs are allowed in security group rules
* ELB health check traffic reaches the backend instances

---

## 5. Validate Ignition Injection via User Data

Ignition is currently injected using:

```
user_data = base64encode(...)
```

Verify that:

* Huawei Cloud correctly passes user-data to the instance
* Ignition is executed by RHCOS during boot

If bootstrap or node provisioning fails, verify:

* User data encoding
* Ignition format
* Maximum user-data size limits

---

## 6. Verify RHCOS Image Compatibility

The deployment assumes that:

```
rhcos_image_id
```

references a **valid RHCOS image uploaded to Huawei Cloud**.

Before running Terraform:

* Confirm the image exists
* Confirm the image supports the selected ECS flavor
* Confirm the image supports Ignition

---

## 7. Confirm ECS Flavor Compatibility

Verify that the selected flavor supports:

* Required CPU and RAM for OpenShift nodes
* Booting from the selected image
* Required disk configuration

Recommended to validate flavors for:

* control-plane nodes
* worker nodes

---

## 8. Validate Security Group Rules

Security groups currently allow:

Control Plane:

* 6443 (API)
* 22623 (Machine Config Server)
* etcd
* kubelet
* overlay network ports

Workers:

* 80 / 443 (Ingress)
* NodePort range
* kubelet
* overlay network ports

If cluster networking fails, verify:

* Geneve / VXLAN ports
* Node-to-node communication
* ELB source CIDR rules

---

## 9. Confirm ELB Health Checks

Ingress health checks are configured as:

```
HTTP
port: 1936
path: /healthz
```

Verify that:

* OpenShift router exposes this endpoint
* Health checks pass once workers join the cluster

---

## 10. Verify DNS Integration

Check that the following records resolve correctly:

Public:

```
api.<cluster>.<domain>
*.apps.<cluster>.<domain>
```

Private:

```
api-int.<cluster>.<domain>
```

Confirm:

* Public DNS zone ID
* Private DNS zone association with VPC

---

## 11. Confirm Terraform Provider Version

The Huawei Cloud provider evolves frequently.

Before troubleshooting module issues, confirm:

```
terraform providers
```

and check compatibility with the provider documentation.

---

## 12. Validate Bootstrap and Cluster Installation Flow

Once all infrastructure is created:

1. Bootstrap node starts
2. Control plane nodes join
3. API becomes available
4. Workers join
5. Ingress router becomes healthy

If the cluster does not converge, review:

* Ignition configuration
* ELB configuration
* Security group rules
* Network reachability

---

## Status

Current state: **Initial functional implementation**

Expected next steps:

* Run Terraform validation
* Adjust provider-specific attributes if necessary
* Validate cluster installation end-to-end
