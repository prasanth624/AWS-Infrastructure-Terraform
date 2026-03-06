# ==============================================================
# Dev Environment Configuration
# ==============================================================

aws_region   = "us-east-1"
project_name = "myproject"
environment  = "dev"

# Networking
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# EC2 / ASG
instance_type = "t3.micro"
asg_min       = 1
asg_max       = 2
asg_desired   = 1

# RDS
db_instance_class = "db.t3.micro"
db_multi_az       = false

# Security
allowed_ssh_cidrs = ["0.0.0.0/0"]
