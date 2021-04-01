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

#conf
mkdir -p /etc/nginx/conf.d
cat <<-EOF > /etc/nginx/conf.d/default.conf
# /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost;
    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    # Proxy pass the api location to save CORS
    # Use location exposed by Consul connect
    location /api {
        proxy_pass http://${upstream_ip}:8080;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF

#app
cat <<-EOF > /docker-compose.yml
version: '3'
services:
  frontend:
    container_name: "frontend"
    network_mode: "host"
    image: "hashicorpdemoapp/frontend:v0.0.3"
    volumes:
       - /etc/nginx/conf.d/:/etc/nginx/conf.d/
EOF

sudo /usr/local/bin/docker-compose up -d
