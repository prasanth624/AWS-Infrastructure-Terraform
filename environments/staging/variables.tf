# Same as dev/variables.tf — copy the file
variable "aws_region" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "instance_type" { type = string }
variable "asg_min" { type = number }
variable "asg_max" { type = number }
variable "asg_desired" { type = number }
variable "db_instance_class" { type = string }
variable "db_multi_az" { type = bool }
variable "allowed_ssh_cidrs" { type = list(string); default = ["0.0.0.0/0"] }
