# Tech Stack

## Backend
- **Language:** Java 8 (source), runs on Java 11 (runtime)
- **Framework:** Spring Boot 2.2.4
- **View Layer:** JSP (JavaServer Pages) with Tomcat Jasper 9.0.31
- **Database:** MySQL (via mysql-connector-java)
- **App Server:** Apache Tomcat 8.5 (embedded in Docker image)
- **Build Tool:** Apache Maven 3.8.6
- **Packaging:** WAR file

## Frontend / Web Tier
- **Reverse Proxy:** Nginx (Amazon Linux based)
- **Proxies to:** Backend app on port 8080

## Infrastructure
- **IaC:** Terraform (AWS provider ~> 6.0)
- **Cloud:** AWS (us-east-1)
- **Resources:** VPC, RDS (MySQL)

## Containers
- **Base Images:** Amazon Linux
- **Registry:** Docker Hub (`xabiere15/java-login-app`)
- **Multi-stage build:** Yes (build stage with Maven, runtime stage with Tomcat)

## CI/CD
- **Platform:** GitHub Actions
- **Trigger:** Push to `master` branch
- **Pipeline:** Checkout → Docker Hub login → Build image → Push image
- **Image tag:** Git commit SHA

## AWS CLI Access
- **Profile:** `corey` (always use `--profile corey` for AWS CLI commands)
- **Region:** `us-east-1`
- **Account:** `236906919633`
- **Role:** `external-access-role` (assumed via STS)
- **ARN:** `arn:aws:sts::236906919633:assumed-role/external-access-role/botocore-session-*`

## Visual Verification
- The **Chrome DevTools MCP** is available for accessing the AWS Console when visual verification is needed.
- The console session is authenticated via Switch Role into account `236906919633` with role `external-access-role` (display name: "Corey").
- Use this for checking resource state, verifying deployments, or any task that benefits from console UI inspection.

## Artifact Repository
- **JFrog Artifactory** configured for release artifacts (libs-release-local)

## Common Commands

```bash
# Build the Java app locally
cd App/java-login-app
./mvnw package

# Build the App Docker image
docker build -t java-login-app ./App

# Build the Web (Nginx) Docker image
docker build -t web-proxy ./Web

# Run tests
cd App/java-login-app
./mvnw test

# Terraform
cd Infrastructure
terraform init
terraform plan
terraform apply
```
