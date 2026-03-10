terraform {
  required_version = ">= 1.5.0"

  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
    }
  }
}

provider "huaweicloud" {
  region = var.cloud_region
}