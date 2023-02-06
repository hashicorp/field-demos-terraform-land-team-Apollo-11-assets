# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_id" "server" {
  byte_length = 4
}

resource "aws_key_pair" "awskey" {
  key_name   = "awskey-${random_id.server.hex}"
  public_key = tls_private_key.awskey.public_key_openssh
}

resource "tls_private_key" "awskey" {
  algorithm = "RSA"
}

resource "null_resource" "awskey" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.awskey.private_key_pem}\" > ~/awskey.pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 ~/awskey.pem"
  }
}
