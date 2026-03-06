aws_region   = "us-east-1"
project_name = "myproject"
environment  = "prod"

vpc_cidr             = "10.2.0.0/16"
public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.10.0/24", "10.2.20.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

instance_type = "t3.medium"
asg_min       = 2
asg_max       = 6
asg_desired   = 2

db_instance_class = "db.t3.medium"
db_multi_az       = true

allowed_ssh_cidrs = ["10.0.0.0/8"]
