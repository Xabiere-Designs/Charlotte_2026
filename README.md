Charlotte_2026 - 3-Tier Application Deployment Project

Started building out a traditional 3-tier web application to strengthen my understanding of infrastructure provisioning, application deployment patterns, CI/CD workflows, containerization, and reverse proxy architecture.

The goal wasn't just to get a Java application running. The goal was to understand how source code moves from a private repository into a running application behind a web server and how that process evolves into a production-grade deployment pipeline.

Architecture

Internet
→ web1 (NGINX)
→ web2 (Tomcat / Java App)
→ RDS (planned)

Server Access

Start SSH agent:

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/<KEY>.pem

Connect to web1:

ssh -A -i ~/.ssh/<KEY>.pem ec2-user@<WEB1_PUBLIC_DNS>

Connect to web2:

ssh -A ec2-user@<WEB2_PRIVATE_IP>

Current Workflow

Bitbucket
→ Maven Build
→ WAR File
→ Tomcat
→ NGINX

Future Workflow

GitHub Actions
→ Docker Build
→ Docker Hub
→ Pull Image
→ Deploy Container