output "output" {
  value = <<README

frontend: ssh -i ~/.ssh/awskey.pem ec2-user@${module.frontend.public_ip}
public-api: ssh -i ~/.ssh/awskey.pem ec2-user@${module.public_api.public_ip}
product-api: ssh -i ~/.ssh/awskey.pem ec2-user@${module.product_api.public_ip}
postgres: ssh -i ~/.ssh/awskey.pem ec2-user@${module.postgres.public_ip}

Takes a while for docker:
http://${module.frontend.public_ip}

README
}

output "environment" {
    value = var.environment
}
