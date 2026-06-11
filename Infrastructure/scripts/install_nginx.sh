#!/bin/bash

# Install NGINX on web1
dnf install -y nginx

# Write reverse proxy config to send web traffic to web2/Tomcat
cat > /etc/nginx/nginx.conf <<EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    server {
        listen 80 default_server;
        server_name _;

        location / {
            proxy_pass http://${web2_private_ip}:8080;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
}
EOF

# Enable and start NGINX
systemctl enable nginx
systemctl restart nginx