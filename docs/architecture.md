# Charlotte 2026 Architecture

## Purpose

Charlotte_2026 is a production-style three-tier DevOps project designed to demonstrate infrastructure provisioning, application deployment, monitoring, testing, and operational readiness.

The project uses Terraform to provision AWS infrastructure and will use Ansible to configure and validate deployed systems.

## Repository Strategy

### Infrastructure_AWS

The `Infrastructure_AWS` repository owns reusable platform components.

It contains:

- Terraform modules
- Ansible roles and playbooks
- Shared bootstrap logic
- Reusable infrastructure documentation

### Charlotte_2026

The `Charlotte_2026` repository owns the application implementation.

It contains:

- Java application source code
- Terraform root configuration
- Project-specific scripts
- Deployment documentation
- Testing and validation assets

## High-Level Architecture

```text
Internet
   |
   v
Public NGINX Server
   |
   v
Private Application Server
   |
   v
Database Tier

Monitoring Server
   |
   |-- Prometheus
   |-- Grafana
   |-- Node Exporter