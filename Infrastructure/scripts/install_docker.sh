#!/bin/bash

# Install Docker on web2
dnf install -y docker

# Enable and start Docker daemon
systemctl enable docker
systemctl start docker

# Pull the latest known working image from Docker Hub
docker pull xabiere15/java-login-app:latest

# Run the Java login application container on port 8080
docker run -d \
  --name java-login-app \
  -p 8080:8080 \
  --restart unless-stopped \
  xabiere15/java-login-app:latest