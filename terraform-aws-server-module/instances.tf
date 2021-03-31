terraform {
  required_version = ">= 0.12"
}

data "aws_ami" "rhel_ami" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["*RHEL-7.3_HVM_GA-*"]
  }
}

data "template_file" "config" {
  template = file("${path.module}/configs/${var.name}.tpl")
  vars = {
    upstream_ip = "${var.upstream_ip}"
  }
}

resource "aws_instance" "instance" {
  instance_type               = "t2.micro"
  ami                         = data.aws_ami.rhel_ami.id
  vpc_security_group_ids      = [ var.security_group_id ]
  subnet_id                   = var.vpc_subnet_ids
  associate_public_ip_address = true
  key_name                    = var.public_key
  iam_instance_profile        = aws_iam_instance_profile.instance.id
  private_ip                  = var.private_ip
  tags                        = var.tags

  user_data = data.template_file.config.rendered
}
