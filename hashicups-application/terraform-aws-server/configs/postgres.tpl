#!/bin/bash

#docker
echo "Installing Docker"
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y --setopt=obsoletes=0 docker-ce-17.03.2.ce-1.el7.centos.x86_64 docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
sudo systemctl enable docker
sudo systemctl start docker

#conf
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

cat <<-EOF > /docker-compose.yml
version: '3'
services:
  postgres:
    network_mode: "host"
    environment:
      POSTGRES_DB: "products"
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "password"
    image: "hashicorpdemoapp/product-api-db:v0.0.11"
EOF

sudo /usr/local/bin/docker-compose up -d
