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

#app
cat <<-EOF > /docker-compose.yml
version: '3'
services:
  public:
    network_mode: "host"
    environment:
      BIND_ADDRESS: ":8080"
      PRODUCT_API_URI: "http://${upstream_ip}:9090"
    image: "hashicorpdemoapp/public-api:v0.0.1"
EOF

sudo /usr/local/bin/docker-compose up -d
