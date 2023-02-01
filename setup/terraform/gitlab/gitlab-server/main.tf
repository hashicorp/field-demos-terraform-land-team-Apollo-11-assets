# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

//GitLab AWS
provider "aws" {
  region = "us-east-2"
}

resource "tls_private_key" "gitlabkey" {
  algorithm = "RSA"
}

resource "aws_key_pair" "gitlabkey" {
  key_name   = "gitlabkey-gitlab"
  public_key = tls_private_key.gitlabkey.public_key_openssh
}

resource "null_resource" "gitlabkey" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.gitlabkey.private_key_pem}\" > ~/.ssh/gitlabkey.pem"
  }
  provisioner "local-exec" {
    command = "chmod 600 ~/.ssh/gitlabkey.pem"
  }
}

resource "aws_vpc" "gitlab" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "gitlab" {
  vpc_id = aws_vpc.gitlab.id
}

resource aws_route_table "gitlab" {
  vpc_id = aws_vpc.gitlab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gitlab.id
  }
}

resource "aws_main_route_table_association" "gitlab" {
  vpc_id         = aws_vpc.gitlab.id
  route_table_id = aws_route_table.gitlab.id
}

resource "aws_subnet" "gitlab" {
  vpc_id     = aws_vpc.gitlab.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_security_group" "http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.gitlab.id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "gitlab" {
  ami           = "ami-0a83c62232ebb66ea" #~13.9.4 Gitlab CE
  instance_type = "t2.medium"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.http.id]
  subnet_id = aws_subnet.gitlab.id
  key_name = aws_key_pair.gitlabkey.key_name
}

output "gitlab_public_address" {
  value       = aws_instance.gitlab.public_ip
}

output "gitlab_password" {
  value       = aws_instance.gitlab.id
}
