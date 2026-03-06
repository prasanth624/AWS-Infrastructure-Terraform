variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "asg_min" {
  description = "ASG min size"
  type        = number
}

variable "asg_max" {
  description = "ASG max size"
  type        = number
}

variable "asg_desired" {
  description = "ASG desired capacity"
  type        = number
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_multi_az" {
  description = "RDS Multi-AZ"
  type        = bool
}

variable "allowed_ssh_cidrs" {
  description = "Allowed SSH CIDRs"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
