# Product Overview

Charlotte_2026 is a web-based login and registration application. It provides user authentication (login/register) backed by a MySQL database, served through a Java Spring Boot backend with an Nginx reverse proxy frontend.

The application is containerized with Docker and deployed to AWS infrastructure provisioned via Terraform. CI/CD is handled through GitHub Actions, building and pushing Docker images to Docker Hub on pushes to the master branch.
