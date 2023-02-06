# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "output" {
  value = <<README

frontend: ssh -i ~/awskey.pem ubuntu@${module.frontend.public_ip}
public-api: ssh -i ~/awskey.pem ubuntu@${module.public_api.public_ip}
product-api: ssh -i ~/awskey.pem ubuntu@${module.product_api.public_ip}
postgres: ssh -i ~/awskey.pem ubuntu@${module.postgres.public_ip}

Takes a few mins to install packages:
http://${module.frontend.public_ip}

README
}

output "environment" {
    value = var.environment
}
