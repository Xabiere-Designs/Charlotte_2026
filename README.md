# Charlotte_2026

Production-style 3-Tier Application Deployment Project demonstrating Infrastructure as Code, CI/CD, containerization, reverse proxy architecture, and cloud-native deployment practices on AWS.

---

## Overview

Charlotte_2026 is an end-to-end DevOps project designed to simulate the deployment lifecycle of a traditional three-tier web application while progressively evolving toward modern cloud-native architecture.

Rather than focusing solely on deploying a Java application, this project emphasizes understanding how infrastructure, application code, automation, networking, and deployment pipelines work together to deliver production-ready software.

The project serves as a hands-on learning platform for Infrastructure as Code (IaC), CI/CD automation, containerization, monitoring, and platform engineering concepts.

---

## Project Objectives

* Provision AWS infrastructure using Terraform
* Deploy a Java web application using Apache Tomcat
* Configure NGINX as a reverse proxy
* Build automated CI/CD pipelines
* Containerize applications with Docker
* Implement infrastructure monitoring
* Demonstrate production deployment patterns
* Practice Git branching and collaborative workflows

---

## Architecture

Current architecture:

```text
                 Internet
                     │
                     ▼
             ┌────────────────┐
             │     NGINX       │
             │     web1        │
             └────────┬────────┘
                      │
                      ▼
             ┌────────────────┐
             │ Apache Tomcat  │
             │ Java Web App   │
             │     web2        │
             └────────┬────────┘
                      │
                      ▼
                Amazon RDS
                 (Planned)
```

---

## Technology Stack

### Cloud

* AWS EC2
* Amazon RDS (planned)

### Infrastructure as Code

* Terraform

### Configuration

* Linux
* SSH
* Bash

### Web Tier

* NGINX

### Application Tier

* Java
* Maven
* Apache Tomcat

### Containerization

* Docker

### CI/CD

* GitHub Actions (planned)
* Bitbucket (current source repository)

### Monitoring

* Prometheus
* Grafana

---

## Repository Structure

```text
Charlotte_2026/
│
├── App/
│   ├── java-login-app/
│   ├── Dockerfile
│   └── Kubernetes/
│
├── terraform/
│
├── ansible/
│
├── scripts/
│
├── docs/
│
└── README.md
```

---

## Current Deployment Workflow

Current application deployment follows a traditional build process.

```text
Developer
      │
      ▼
 Bitbucket Repository
      │
      ▼
 Maven Build
      │
      ▼
 WAR Artifact
      │
      ▼
 Apache Tomcat
      │
      ▼
 NGINX Reverse Proxy
      │
      ▼
 Browser
```

---

## Target Deployment Workflow

The long-term objective is to automate application delivery using containerized deployments.

```text
Developer
      │
      ▼
GitHub Repository
      │
      ▼
GitHub Actions
      │
      ▼
Build Docker Image
      │
      ▼
Docker Hub
      │
      ▼
Pull Latest Image
      │
      ▼
Docker Container
      │
      ▼
NGINX Reverse Proxy
      │
      ▼
Production Deployment
```

Future enhancements include:

* Infrastructure provisioning through Terraform
* Automated configuration using Ansible
* Container orchestration with Kubernetes
* Continuous Deployment
* Blue/Green deployment strategies
* Rolling deployments
* Automated rollback

---

## Infrastructure Provisioning

Terraform is used to provision and manage cloud infrastructure.

### Initialize

```bash
terraform init
```

### Format

```bash
terraform fmt
```

### Validate

```bash
terraform validate
```

### Generate Execution Plan

```bash
terraform plan -out=tfplan
```

### Review Plan

```bash
terraform show tfplan
```

### Apply Infrastructure

```bash
terraform apply tfplan
```

Using an immutable execution plan ensures the reviewed infrastructure matches what is deployed.

---

## Server Access

### Start SSH Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/<KEY>.pem
```

### Connect to Web Server

```bash
ssh -A -i ~/.ssh/<KEY>.pem ec2-user@<WEB1_PUBLIC_DNS>
```

### Connect to Application Server

```bash
ssh -A ec2-user@<WEB2_PRIVATE_IP>
```

### Verify Public IP

```bash
curl ifconfig.me
```

---

## Monitoring

Application health and infrastructure metrics are monitored using Prometheus and Grafana.

### Prometheus

```bash
sudo systemctl status prometheus

curl localhost:9090
```

### Grafana

```bash
sudo systemctl status grafana-server

curl localhost:3000
```

Future monitoring enhancements include:

* Node Exporter
* Alertmanager
* Custom application metrics
* Infrastructure dashboards
* Availability monitoring

---

## DevOps Practices Demonstrated

* Infrastructure as Code
* Git Branching Strategy
* Immutable Infrastructure
* Reverse Proxy Architecture
* CI/CD Pipeline Design
* Artifact-Based Deployments
* Containerization
* Monitoring and Observability
* Linux Administration
* Cloud Infrastructure Provisioning

---

## Future Roadmap

### Infrastructure

* Amazon RDS
* Security Groups
* Application Load Balancer
* Route53
* Auto Scaling

### CI/CD

* GitHub Actions
* Automated Testing
* Security Scanning
* Docker Image Versioning
* Deployment Automation

### Kubernetes

* Deploy application to EKS
* Helm Charts
* Ingress Controller
* Horizontal Pod Autoscaler

### Security

* Trivy
* Snyk
* Checkov
* GitGuardian
* OWASP ZAP

### Monitoring

* Node Exporter
* Alertmanager
* Loki
* Grafana Dashboards

---

## Lessons Learned

This project has provided practical experience with:

* End-to-end application deployment
* Linux server administration
* Terraform workflows
* Reverse proxy configuration
* Java application hosting
* CI/CD architecture
* Containerization strategies
* Infrastructure troubleshooting
* Monitoring and observability

Each iteration expands the platform toward production-grade deployment practices while reinforcing core DevOps engineering principles.

---

## Maintainer

**Corey L. Ducre**

Platform Engineering | DevOps | Cloud Infrastructure

Xabiere Designs, Inc.