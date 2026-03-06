variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Custom AMI ID (leave empty for latest Amazon Linux 2023)"
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "app_sg_id" {
  description = "Application security group ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ASG"
  type        = list(string)
}

variable "target_group_arns" {
  description = "ALB target group ARNs"
  type        = list(string)
  default     = []
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name passed to userdata template"
  type        = string
  default     = "none"
}

variable "db_host" {
  description = "Database hostname passed to userdata template"
  type        = string
  default     = "none"
}

variable "asg_min" {
  description = "ASG minimum size"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "ASG maximum size"
  type        = number
  default     = 3
}

variable "asg_desired" {
  description = "ASG desired capacity"
  type        = number
  default     = 1
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
