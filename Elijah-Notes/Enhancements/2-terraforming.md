# Enhancement #2: Terraforming the Charlotte_2026 Infrastructure

**Status:** TODO
**Prereq:** Discovery #1 (resource inventory)

---

## Objective

Design and build out the Terraform repo so the existing AWS infrastructure is managed as code. This doc lays out the **repo design**, then walks through **importing** the existing resources into state.

---

## 1. Terraform Repo Design

### Proposed directory layout

```
Infrastructure/
├── providers.tf         # Provider + S3 backend config
├── versions.tf          # Required Terraform & provider versions
├── variables.tf         # Input variable declarations
├── outputs.tf           # Useful outputs (instance IPs, sg ids, etc.)
├── network.tf           # VPC, subnets, IGW, route tables
├── security.tf          # Security groups
├── compute.tf           # EC2 instances, key pairs
├── iam.tf               # IAM roles + instance profiles (SSM)
├── storage.tf           # S3 buckets
├── imports.tf           # import blocks (can be removed after import)
└── envs/
    ├── current.tfvars   # values for the existing/current stack
    └── new.tfvars       # values for the new stack
```

> Workspaces + tfvars are detailed separately in Enhancement #4. For the initial import, a single default config is fine.

### Backend (remote state)

You already have an S3 bucket that looks purpose-built for this: `xabiere-comcast-terraform-state`

`Infrastructure/providers.tf`:

```hcl
terraform {
  backend "s3" {
    bucket  = "xabiere-comcast-terraform-state"
    key     = "charlotte-2026/terraform.tfstate"
    region  = "us-east-1"
    profile = "corey"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "corey"
}
```

**Docs:** https://developer.hashicorp.com/terraform/language/backend/s3

> Make sure the state bucket has **versioning enabled** for rollback safety.

---

## 2. IAM / SSM — IMPORTANT

The existing EC2s mostly rely on the `Diamond` key pair for SSH. Going forward you should add **SSM access** so you can manage instances without SSH/key pairs.

### What to add

1. An IAM role for EC2 with the AWS managed policy **`AmazonSSMManagedInstanceCore`** attached.
2. An instance profile wrapping that role.
3. Attach the instance profile to the EC2 instances.

`Infrastructure/iam.tf`:

```hcl
resource "aws_iam_role" "ssm_ec2" {
  name = "charlotte-ssm-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_ec2" {
  name = "charlotte-ssm-ec2-profile"
  role = aws_iam_role.ssm_ec2.name
}
```

Then reference it on instances in `compute.tf`:

```hcl
resource "aws_instance" "web" {
  # ... other args populated from import ...
  iam_instance_profile = aws_iam_instance_profile.ssm_ec2.name
}
```

**Why:** `AmazonSSMManagedInstanceCore` lets the SSM Agent register the instance with Systems Manager — enabling Session Manager (browser/CLI shell), Patch Manager, and Run Command without opening port 22.

**Docs:**
- SSM managed policy: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonSSMManagedInstanceCore.html
- Setting up SSM for EC2: https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-permissions.html

---

## 3. Importing Existing Resources

### 3a. Write resource blocks first

Before importing, Terraform needs a matching resource block in your `.tf` files. Stub them out — you don't need every argument yet, the import will reveal what's required:

```hcl
resource "aws_vpc" "default" {}
resource "aws_internet_gateway" "default" {}
resource "aws_subnet" "default_1a" {}
resource "aws_security_group" "devops_test" {}
```

### 3b. Import using `import` blocks (recommended, Terraform 1.5+)

Add import blocks to `Infrastructure/imports.tf`:

```hcl
import {
  to = aws_vpc.default
  id = "vpc-04d7faf6e02a72914"
}

import {
  to = aws_internet_gateway.default
  id = "igw-00de80020d7ed98b6"
}

import {
  to = aws_instance.web
  id = "i-0dcd4c4be9ccec9a2"
}
```

Then run `terraform plan -generate-config-out=generated.tf` to have Terraform scaffold the resource config for you.

**Docs:**
- Import blocks: https://developer.hashicorp.com/terraform/language/import
- Generating config from imports: https://developer.hashicorp.com/terraform/language/import/generating-configuration

### 3c. Alternative: CLI import (one resource at a time)

```bash
terraform import aws_vpc.default vpc-04d7faf6e02a72914
terraform import aws_instance.web i-0dcd4c4be9ccec9a2
```

**Docs:** https://developer.hashicorp.com/terraform/cli/import

### 3d. Recommended import order

1. VPC
2. Internet Gateway
3. Subnets (6)
4. Route Tables
5. Security Groups (start with the active ones: `DevOps_Test_Security_Group`, `Jenkins_Test_Environment_sg`)
6. Key Pairs
7. EC2 Instances (start with the 2 running ones: `web`, `web 2`)
8. S3 Buckets (at minimum: `xabiere-comcast-terraform-state`)
9. IAM Roles (`external-access-role` only — don't import service-linked roles)

### 3e. Resource IDs to import

| Resource | Terraform Type | ID |
|----------|----------------|----|
| Default VPC | aws_vpc | `vpc-04d7faf6e02a72914` |
| Internet Gateway | aws_internet_gateway | `igw-00de80020d7ed98b6` |
| Main Route Table | aws_route_table | `rtb-041122b0bc549e5c5` |
| web (running) | aws_instance | `i-0dcd4c4be9ccec9a2` |
| web 2 (running) | aws_instance | `i-06fbff1385a1e5a10` |
| DevOps_Test SG | aws_security_group | `sg-0d6f8d4385791673b` |
| Jenkins_Test SG | aws_security_group | `sg-02b7a24d99a8d3c03` |
| State bucket | aws_s3_bucket | `xabiere-comcast-terraform-state` |
| external-access-role | aws_iam_role | `external-access-role` |

> See Discovery #1 for the full inventory of subnets, SGs, instances, and key pairs.

---

## 4. Validate

After importing, run:

```bash
terraform plan
```

The goal is a clean plan with **no changes** — meaning your `.tf` files match the real state. Fix any drift the plan shows.

> Note: adding the SSM instance profile to instances that don't currently have one **will** show as a change — that's expected and intended. Apply it deliberately.

---

## Resource-Specific Import Docs

| Resource Type | Registry Import Docs |
|---------------|---------------------|
| aws_vpc | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#import |
| aws_subnet | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#import |
| aws_internet_gateway | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway#import |
| aws_route_table | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table#import |
| aws_security_group | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#import |
| aws_instance | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#import |
| aws_key_pair | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair#import |
| aws_s3_bucket | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import |
| aws_iam_role | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#import |
| aws_iam_instance_profile | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile#import |

---

## Tips

- Use `terraform state list` to see what's already in state
- Use `terraform state show <resource>` to see imported attributes
- Don't import the Cloud9 instance or its security group — those are CloudFormation-managed
- Don't import AWS service-linked roles (paths like `/aws-service-role/`)
- Keep `imports.tf` separate so you can delete it once everything is in state
