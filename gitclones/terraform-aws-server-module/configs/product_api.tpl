#!/bin/bash

#Docker
echo "Installing Docker"
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y --setopt=obsoletes=0 docker-ce-17.03.2.ce-1.el7.centos.x86_64 docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
sudo systemctl enable docker
sudo systemctl start docker

#creds
sudo mkdir -p /etc/secrets
sudo bash -c 'cat <<-EOF > /etc/secrets/db-creds
{
"db_connection": "host=${upstream_ip} port=5432 user=postgres password=password dbname=products sslmode=disable",
  "bind_address": ":9090",
  "metrics_address": ":9103"
}
EOF'

#app
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo bash -c 'cat <<-EOF > /docker-compose.yml
version: "3"
services:
  product:
    network_mode: "host"
    environment:
      CONFIG_FILE: "/etc/secrets/db-creds"
    image: "hashicorpdemoapp/product-api:v0.0.11"
    volumes:
       - /etc/secrets/db-creds:/etc/secrets/db-creds
EOF'

#Waiting for Postgres to come up
sleep 120
sudo /usr/local/bin/docker-compose up -d
