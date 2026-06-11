# Public IP to use for Route53 A record or browser testing
output "web1_public_ip" {
  description = "Public IP address of web1"
  value       = module.three_tier_ec2.web1_public_ip
}

# Public DNS for SSH access to web1
output "web1_public_dns" {
  description = "Public DNS name of web1"
  value       = module.three_tier_ec2.web1_public_dns
}

# Private IP of web2 used by NGINX upstream proxy
output "web2_private_ip" {
  description = "Private IP address of web2"
  value       = module.three_tier_ec2.web2_private_ip
}

# VPC ID created by the VPC module
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}