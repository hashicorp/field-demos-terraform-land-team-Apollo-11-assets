# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "name" { default = "rchao" }
variable "private_subnets" { type = list(string)}
variable "public_subnets" { type = list(string)}
variable "cidr_block" {}
