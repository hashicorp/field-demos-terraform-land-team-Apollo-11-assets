#!/bin/bash

#docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

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

sudo /usr/local/bin/docker-compose up -d
