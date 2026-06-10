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

module "three_tier_ec2" {
  source = "git::https://github.com/Xabiere-Designs/Infrastructure_AWS.git//modules/three_tier_ec2"

  project_name      = "charlotte-2026"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]

  aws_ami       = var.aws_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  my_ip_cidr    = var.my_ip_cidr
}