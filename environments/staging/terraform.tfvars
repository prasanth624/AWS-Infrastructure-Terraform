aws_region   = "us-east-1"
project_name = "myproject"
environment  = "staging"

vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

instance_type = "t3.small"
asg_min       = 2
asg_max       = 3
asg_desired   = 2

db_instance_class = "db.t3.small"
db_multi_az       = false

allowed_ssh_cidrs = ["10.0.0.0/8"]
