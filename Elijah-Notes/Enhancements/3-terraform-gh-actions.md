# Enhancement #3: Create GitHub Actions Workflow for Terraform CI/CD

**Status:** TODO  
**Prereq:** Enhancement #2 (resources imported into state)

---

## Objective

Create a GitHub Actions workflow at `.github/workflows/terraform.yaml` that automates Terraform plan/apply through the pipeline so infrastructure changes go through the same PR review process as application code.

---

## Requirements

1. **Trigger on PRs** that modify `Infrastructure/` — run `terraform plan` and post output as a PR comment
2. **Trigger on push to master** — run `terraform apply` automatically
3. **Manual dispatch** — ability to run plan/apply/destroy on demand
4. **Format & validate** — check `terraform fmt` and `terraform validate` before planning

---

## Steps

### 1. Create an IAM user for GitHub Actions (or use OIDC)

**Option A — IAM User (simpler):**
- Create a user like `github-actions-terraform`
- Attach `AdministratorAccess` for now (scope down later)
- Generate access keys
- Add as repo secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

**Option B — OIDC (more secure, no long-lived keys):**
- Docs: https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

---

### 2. Create the workflow file

Path: `.github/workflows/terraform.yaml`

**Key actions to use:**
- `actions/checkout@v4`
- `aws-actions/configure-aws-credentials@v4`
- `hashicorp/setup-terraform@v3`

**Docs:**
- GitHub Actions workflow syntax: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
- setup-terraform action: https://github.com/hashicorp/setup-terraform
- configure-aws-credentials: https://github.com/aws-actions/configure-aws-credentials

---

### 3. Workflow structure

```yaml
name: Terraform Deploy

on:
  push:
    branches: [master]
    paths: ['Infrastructure/**']
  pull_request:
    branches: [master]
    paths: ['Infrastructure/**']
  workflow_dispatch:
    inputs:
      action:
        description: 'Terraform action'
        required: true
        default: 'plan'
        type: choice
        options: [plan, apply, destroy]
```

**Steps to include:**
1. Checkout code
2. Configure AWS credentials (from secrets)
3. Setup Terraform (pin a version like `1.9.0`)
4. `terraform fmt -check`
5. `terraform init`
6. `terraform validate`
7. `terraform plan -out=tfplan`
8. (On PR) Post plan as comment using `actions/github-script@v7`
9. (On master push or manual apply) `terraform apply tfplan`

---

### 4. Add repo secrets

Go to: **Repo → Settings → Secrets and variables → Actions**

Add:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

### 5. Test it

1. Create a branch, make a small Terraform change
2. Open a PR — verify the plan shows up as a comment
3. Merge — verify apply runs on master

---

## Reference Workflows

- HashiCorp's official tutorial: https://developer.hashicorp.com/terraform/tutorials/automation/github-actions
- Example workflow: https://github.com/hashicorp/setup-terraform#usage

---

## Security Notes

- Never commit AWS credentials to the repo
- Scope the IAM policy to only what Terraform needs (after initial setup)
- Consider adding `terraform plan` approval gates for production
- The state bucket (`xabiere-comcast-terraform-state`) should have versioning enabled for rollback safety
