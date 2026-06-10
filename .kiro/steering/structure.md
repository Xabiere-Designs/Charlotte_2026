# Project Structure

```
Charlotte_2026/
├── App/                          # Backend application container
│   ├── Dockerfile                # Multi-stage: Maven build → Tomcat runtime
│   └── java-login-app/           # Spring Boot application
│       ├── pom.xml               # Maven project config
│       ├── mvnw / mvnw.cmd       # Maven wrapper scripts
│       ├── settings.xml          # Maven settings (Artifactory)
│       └── src/
│           ├── main/
│           │   ├── java/com/dpt/demo/   # Java source (controllers, app entry)
│           │   ├── resources/           # application.properties
│           │   └── webapp/pages/        # JSP view templates
│           └── test/                    # Unit tests
├── Web/                          # Nginx reverse proxy container
│   ├── Dockerfile                # Amazon Linux + Nginx
│   └── nginx.conf                # Proxy config (port 80 → app:8080)
├── Infrastructure/               # Terraform IaC
│   └── providers.tf              # AWS provider, VPC definition
├── .github/workflows/            # CI/CD pipelines
│   └── ci.yaml                   # Docker build & push on master
└── README.md
```

## Key Conventions

- **Package structure:** `com.dpt.demo` — all controllers live in this single package
- **Controller naming:** Lowercase class names for feature controllers (`login`, `register`), PascalCase for the home controller (`HomeController`)
- **View resolution:** JSP files in `src/main/webapp/pages/`, resolved via Spring prefix/suffix config
- **Database access:** Direct JDBC via `DriverManager` (no ORM/JPA layer)
- **Configuration:** Database credentials and view config in `application.properties`
- **Docker images:** Both containers use Amazon Linux as the base image
- **Branch strategy:** `master` is the primary branch; pushes trigger CI
