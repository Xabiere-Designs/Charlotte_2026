# Creates the network foundation for the 3-tier application
module "vpc" {
  source = "git::https://github.com/Xabiere-Designs/Infrastructure_AWS.git//modules/vpc"

  name = "charlotte-2026"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]

  tags = {
    Project = "Charlotte_2026"
    Owner   = "Corey"
  }
}

# Creates web1 and web2 EC2 instances inside the VPC
module "three_tier_ec2" {
  source = "git::https://github.com/Xabiere-Designs/Infrastructure_AWS.git//modules/three_tier_ec2"

  project_name      = "charlotte-2026"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]

  aws_ami         = var.aws_ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  my_ip_cidr      = var.my_ip_cidr
  web2_private_ip = var.web2_private_ip

  # NGINX needs the static private IP of web2 for reverse proxy routing
  web1_user_data = templatefile("${path.module}/scripts/install_nginx.sh", {
    web2_private_ip = var.web2_private_ip
  })

  # web2 installs Docker and runs the Java login app container
  web2_user_data = file("${path.module}/scripts/install_docker.sh")
}

# Creates dedicated private monitoring server for Prometheus and Grafana
module "monitoring_ec2" {
  source = "git::https://github.com/Xabiere-Designs/Infrastructure_AWS.git//modules/monitoring_ec2"

  project_name           = "charlotte-2026"
  vpc_id                 = module.vpc.vpc_id
  private_subnet_id      = module.vpc.private_subnet_ids[1]
  web1_security_group_id = module.three_tier_ec2.web1_security_group_id

  aws_ami       = var.aws_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  monitoring_user_data = file("${path.module}/scripts/install_monitoring.sh")

  tags = {
    Project = "Charlotte_2026"
    Owner   = "Corey"
    Tier    = "Monitoring"
  }
}