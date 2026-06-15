# Scan for vulnerabilities using Trivy
To scan for vulnerabilities in the project, you can use Trivy, a comprehensive vulnerability scanner for containers and other artifacts. Here's how you can set it up and run a scan:
1. **Install Trivy**: You can install Trivy by following the instructions on the [Trivy GitHub repository](
    Download Trivy binary as root
        wget https://github.com/aquasecurity/trivy/releases/download/v0.71.1/trivy_0.71.1_Linux-64bit.tar.gz

    Copy the binary to working directory
        cp trivy /usr/local/bin/

    Install Docker and give permission to Pipeline user
        after installing Docker run,
        adduser <ci/cd pipeline> docker

    Scan using Trivy
        trivy fs --severity HIGH,CRITICAL .
        trivy image nginx:latest .
    )