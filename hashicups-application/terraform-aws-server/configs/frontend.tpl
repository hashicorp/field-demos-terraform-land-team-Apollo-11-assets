#!/bin/bash

#docker
echo "Installing Docker"
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y --setopt=obsoletes=0 docker-ce-17.03.2.ce-1.el7.centos.x86_64 docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
sudo systemctl enable docker
sudo systemctl start docker

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

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

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
