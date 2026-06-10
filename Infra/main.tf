module "vpc" {
  source = "git::https://github.com/Xabiere-Designs/Infrastructure_AWS.git//modules/vpc"

  name     = "Charlotte_2026-vpc"
  vpc_cidr = "10.0.0.0/16"
}