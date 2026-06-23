# AMI used by web1 and web2
variable "aws_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

# EC2 instance size for web1 and web2
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# EC2 instance size for dedicated monitoring server
variable "monitoring_instance_type" {
  description = "EC2 instance type for Prometheus and Grafana monitoring server"
  type        = string
  default     = "t3.small"
}

# Existing EC2 key pair used for SSH access
variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

# Your public IP in CIDR notation for SSH into web1
variable "my_ip_cidr" {
  description = "Your public IP in CIDR notation for SSH access"
  type        = string
}

# Static private IP for web2 inside the first private subnet
variable "web2_private_ip" {
  description = "Static private IP assigned to the web2 application server"
  type        = string
  default     = "10.0.160.10"
}