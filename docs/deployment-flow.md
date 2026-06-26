cat > docs/deployment-flow.md <<'EOF'
# Deployment Flow

## Purpose

This document explains how Charlotte_2026 moves from source code and infrastructure code into a deployed AWS environment.

## Current Deployment Lifecycle

```text
Developer
   |
   v
GitHub Branch
   |
   v
Terraform Root in Charlotte_2026/Infrastructure
   |
   v
Reusable Modules from Infrastructure_AWS
   |
   v
AWS Infrastructure
   |
   v
Bootstrap Scripts
   |
   v
Monitoring and Application Validation