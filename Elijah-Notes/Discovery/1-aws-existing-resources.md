# Discovery: Existing AWS Resources in Corey's Account (236906919633)

**Date:** 2026-06-04  
**Region:** us-east-1

## Summary

Explored Corey's AWS account to identify all existing resources that need to be imported into Terraform state management.

---

## Resources to Import

### 1. VPC (Default)
| Resource | ID | Details |
|----------|----|---------|
| VPC | `vpc-04d7faf6e02a72914` | 172.31.0.0/16, default VPC, tagged "default_vpc" |

### 2. Subnets (6 default subnets)
| Subnet ID | AZ | CIDR |
|-----------|----|------|
| `subnet-0c21674c5ed7e51d2` | us-east-1c | 172.31.0.0/20 |
| `subnet-00fdc8e6b062ca8a4` | us-east-1a | 172.31.16.0/20 |
| `subnet-01710be854144046e` | us-east-1f | 172.31.64.0/20 |
| `subnet-0447ce52f614e5272` | us-east-1d | 172.31.80.0/20 |
| `subnet-053aec8add0c17a1a` | us-east-1b | 172.31.32.0/20 |
| `subnet-0e31cadbbccdfb57f` | us-east-1e | 172.31.48.0/20 |

### 3. Internet Gateway
| Resource | ID | Attached To |
|----------|----|-------------|
| IGW | `igw-00de80020d7ed98b6` | vpc-04d7faf6e02a72914 |

### 4. Route Table
| Resource | ID | Routes |
|----------|----|--------|
| Main RT | `rtb-041122b0bc549e5c5` | local + 0.0.0.0/0 → igw |

### 5. Security Groups (13 total)
| Name | ID | Purpose/Ports |
|------|----|---------------|
| default | `sg-07f7ce393958aaa71` | 22, 80, 443, 8080, 9090 |
| DevOps_Test_Security_Group | `sg-0d6f8d4385791673b` | 22, 80, 8080, ICMP |
| Jenkins_Security_Group_CI/CD | `sg-0efa1397c34255858` | 22, 8080 |
| Jenkins_Test_Environment_sg | `sg-02b7a24d99a8d3c03` | 22, 80, 8080, 9100 (internal) |
| launch-wizard-1 (DevOps_Security_Group) | `sg-003362dfd5518a7fc` | 22, 3000, 8080 |
| launch-wizard-4 | `sg-0b7d0fe13d8532fea` | 22, 80, 8080 |
| launch-wizard-5 | `sg-0f213d39b2ea29af5` | 22, 80 |
| launch-wizard-6 | `sg-005053d59f4e0949e` | 22, 80 |
| Jenkins server security group (allow_tls) | `sg-02a31f7d55924f5e2` | 22, 443, 8080 |
| Terraform_SG (launch-wizard-17) | `sg-094f0c3d8fae7e0dc` | 22 (restricted) |
| launch-wizard-20 | `sg-0d33892816e6e7fcd` | 22 (restricted), 0-65535 |
| launch-wizard-2 | `sg-05c68c01695021b76` | 22 (restricted) |
| launch-wizard-3 | `sg-000b79ca7b83e0378` | 22 |
| Cloud9 SG | `sg-035c69dd9a131566a` | No inbound (Cloud9 managed) |

### 6. EC2 Instances (11 total)
| Name | ID | Type | State | Key |
|------|----|------|-------|-----|
| web | `i-0dcd4c4be9ccec9a2` | t3.micro | **running** | Diamond |
| web 2 | `i-06fbff1385a1e5a10` | t3.micro | **running** | Diamond |
| Jenkins server ami | `i-0ac01344e67ed369d` | t2.micro | stopped | Diamond |
| Maven | `i-075a12563834d905b` | t2.micro | stopped | Diamond |
| nginx | `i-08989aff54ba1757b` | t2.micro | stopped | Diamond |
| Tomcat_2025 | `i-0a3e679d906e9738b` | t2.micro | stopped | Diamond |
| Docker-Engine | `i-0109a119fc5439d33` | t2.micro | stopped | Diamond |
| Grafana | `i-0514d2d6d20023dba` | t3.micro | stopped | Diamond |
| kubernetes | `i-08899fe6657be2d25` | t3.micro | stopped | Diamond |
| boto3 | `i-052fcbf28acc59b37` | t2.micro | stopped | Diamond |
| Cloud9 (green-money-team) | `i-03e479a6fa940c7c7` | t2.micro | stopped | — |

### 7. Key Pairs (6)
| Name | ID |
|------|----|
| Charlotte | `key-060abc8928571dc96` |
| Diamond | `key-04318aa02e39df8df` → Most instances use this |
| Corey | `key-0ed55c5cb35e5f001` |
| Aquarian | `key-04318aa02e39df8df` |
| Leveled_up | `key-04ffd923134734a2f` |
| Level-Up | `key-01b26a8c81f7f3de6` |

### 8. S3 Buckets (6)
| Bucket Name | Created |
|-------------|---------|
| `cd50624` | 2024-05-06 |
| `elasticbeanstalk-us-east-1-236906919633` | 2019-05-10 |
| `luxxy-covid-testing-system-pdf-en-cd310` | 2023-08-23 |
| `naval-repair-data` | 2025-01-03 |
| `xabiere-comcast-terraform-state` | 2025-10-19 |
| `xabiere-tf-test-bucket` | 2026-02-12 |

### 9. IAM Roles (notable custom ones)
| Role Name | Purpose |
|-----------|---------|
| `external-access-role` | Cross-account access for Elijah |
| `ec2_scheduler` | Lambda-based EC2 scheduling |
| `CloudWatch` | Lambda → CloudWatch |
| `WK8_Ec2` | EC2 instance role |
| `rds-monitoring-role` | RDS enhanced monitoring |

### 10. RDS
- **No active RDS instances** (the app references `ed-web-db.cdgiiabcm6en.us-east-1.rds.amazonaws.com` but it's been deleted/stopped)

### 11. ECS / ECR
- No ECS clusters
- No ECR repositories

---

## Resources NOT Found
- No RDS instances currently running
- No ECS/ECR resources
- No EKS clusters (service-linked roles exist but no clusters)

---

## Terraform Import Documentation

Corey should reference the following docs to learn how to import each resource type:

- **terraform import command:** https://developer.hashicorp.com/terraform/cli/import
- **Import block (declarative, recommended):** https://developer.hashicorp.com/terraform/language/import
- **aws_vpc:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#import
- **aws_subnet:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#import
- **aws_internet_gateway:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway#import
- **aws_route_table:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table#import
- **aws_security_group:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#import
- **aws_instance:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#import
- **aws_key_pair:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair#import
- **aws_s3_bucket:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import
- **aws_iam_role:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#import

---

## Recommended Import Strategy

1. Start with networking: VPC → Subnets → IGW → Route Tables → Security Groups
2. Then compute: Key Pairs → EC2 Instances
3. Then storage: S3 Buckets
4. Then IAM: Roles (only custom ones worth managing)

Use Terraform `import` blocks in a `.tf` file for a declarative approach (Terraform 1.5+), or the `terraform import` CLI command for one-offs.
