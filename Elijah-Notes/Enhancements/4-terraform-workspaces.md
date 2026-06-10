# Enhancement #4: Configure Terraform Workspaces and tfvars for Multi-Environment

**Status:** TODO  
**Prereq:** Enhancement #2 (resources imported), Enhancement #3 (CI/CD pipeline)

---

## Objective

Use Terraform workspaces and variable files (`.tfvars`) to manage multiple environments (e.g., your current stack vs. a new one) from the same codebase without duplicating `.tf` files.

---

## Concept

- **Workspaces** = separate state files for the same configuration
- **tfvars** = environment-specific values (instance types, counts, names, etc.)
- Together they let you run `terraform workspace select prod` + `terraform apply -var-file=prod.tfvars` to target different environments

---

## Steps

### 1. Restructure `Infrastructure/` directory

```
Infrastructure/
├── main.tf              # Resource definitions (parameterized)
├── variables.tf         # Variable declarations
├── outputs.tf           # Output values
├── providers.tf         # Provider + backend config
├── envs/
│   ├── current.tfvars   # Values for existing/current stack
│   └── new.tfvars       # Values for new stack
```

---

### 2. Define variables

In `Infrastructure/variables.tf`:

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of web instances"
  type        = number
  default     = 2
}
```

---

### 3. Create tfvars files

`Infrastructure/envs/current.tfvars`:
```hcl
environment    = "current"
instance_type  = "t3.micro"
instance_count = 2
```

`Infrastructure/envs/new.tfvars`:
```hcl
environment    = "new"
instance_type  = "t3.micro"
instance_count = 2
```

---

### 4. Create and use workspaces

```bash
cd Infrastructure

# Create workspaces
terraform workspace new current
terraform workspace new new

# Switch to a workspace
terraform workspace select current

# Apply with the matching tfvars
terraform apply -var-file=envs/current.tfvars
```

---

### 5. Update the backend key to include workspace

Terraform workspaces automatically namespace state within S3:
```
s3://xabiere-comcast-terraform-state/charlotte-2026/terraform.tfstate
```
becomes:
```
s3://xabiere-comcast-terraform-state/env:/current/charlotte-2026/terraform.tfstate
s3://xabiere-comcast-terraform-state/env:/new/charlotte-2026/terraform.tfstate
```

---

### 6. Update GitHub Actions to support workspaces

In the workflow, add a workspace input:

```yaml
workflow_dispatch:
  inputs:
    workspace:
      description: 'Terraform workspace'
      required: true
      default: 'current'
      type: choice
      options: [current, new]
```

And in steps:
```yaml
- name: Select Workspace
  run: terraform workspace select ${{ github.event.inputs.workspace }}
```

---

## Docs

- Terraform Workspaces: https://developer.hashicorp.com/terraform/language/state/workspaces
- Input Variables: https://developer.hashicorp.com/terraform/language/values/variables
- Variable Definitions Files: https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files
- Backend S3 + Workspaces: https://developer.hashicorp.com/terraform/language/backend/s3#workspaces

---

## Tips

- Don't use `default` workspace for real infra — always create named ones
- Keep tfvars files committed to the repo (they shouldn't contain secrets)
- Secrets (like DB passwords) should use `TF_VAR_` environment variables or AWS Secrets Manager
- Use `terraform.workspace` in your .tf files to conditionally name resources:
  ```hcl
  resource "aws_instance" "web" {
    tags = {
      Name = "web-${terraform.workspace}"
    }
  }
  ```
