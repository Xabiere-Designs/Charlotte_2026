
## `docs/roadmap.md`

```bash
cat > docs/roadmap.md <<'EOF'
# Charlotte 2026 Roadmap

## Epic 1: Infrastructure Foundation

- [x] Create VPC
- [x] Create public and private subnets
- [x] Create Internet Gateway
- [x] Create NAT Gateway
- [x] Create route tables
- [x] Create EC2 security groups
- [x] Deploy public NGINX server
- [x] Deploy private application server
- [x] Deploy private monitoring server

## Epic 2: Observability

- [x] Install Prometheus
- [x] Install Grafana
- [x] Install Node Exporter
- [ ] Configure NGINX reverse proxy for monitoring access
- [ ] Add Prometheus alert rules
- [ ] Add Alertmanager
- [ ] Add Grafana dashboards

## Epic 3: Configuration Management

- [ ] Add reusable Ansible structure in Infrastructure_AWS
- [ ] Configure NGINX reverse proxy with Ansible
- [ ] Add monitoring health probes
- [ ] Add smoke test automation
- [ ] Generate Ansible inventory from Terraform outputs

## Epic 4: Database Tier

- [ ] Add RDS module
- [ ] Configure private database subnet access
- [ ] Add database security group rules
- [ ] Add backup configuration
- [ ] Add Secrets Manager integration

## Epic 5: CI/CD

- [ ] Add Terraform validation workflow
- [ ] Add Terraform plan workflow
- [ ] Add application build workflow
- [ ] Add Docker image build and push
- [ ] Add smoke test workflow
- [ ] Add deployment documentation

## Epic 6: Production Hardening

- [ ] Add AWS Systems Manager access
- [ ] Reduce SSH dependency
- [ ] Add IAM instance profiles
- [ ] Add VPC endpoints
- [ ] Add least-privilege IAM policies
EOF