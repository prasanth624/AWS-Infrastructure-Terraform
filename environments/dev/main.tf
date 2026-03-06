# ==============================================================
# Provider
# ==============================================================
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# ==============================================================
# Locals
# ==============================================================
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "aws-terraform-infrastructure"
  }
}

# ==============================================================
# VPC Module
# ==============================================================
module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  common_tags          = local.common_tags
}

# ==============================================================
# Security Groups Module
# ==============================================================
module "security_groups" {
  source = "../../modules/security-groups"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  common_tags      = local.common_tags
}

# ==============================================================
# IAM Module — policies loaded from .tpl files
# ==============================================================
module "iam" {
  source = "../../modules/iam"

  project_name   = var.project_name
  environment    = var.environment
  s3_bucket_name = module.s3.bucket_id
  common_tags    = local.common_tags
}

# ==============================================================
# ALB Module
# ==============================================================
module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  common_tags       = local.common_tags
}

# ==============================================================
# RDS Module
# ==============================================================
module "rds" {
  source = "../../modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  instance_class     = var.db_instance_class
  multi_az           = var.db_multi_az
  private_subnet_ids = module.vpc.private_subnet_ids
  db_sg_id           = module.security_groups.db_sg_id
  common_tags        = local.common_tags
}

# ==============================================================
# S3 Module — bucket policy loaded from .tpl file
# ==============================================================
module "s3" {
  source = "../../modules/s3"

  project_name      = var.project_name
  environment       = var.environment
  bucket_suffix     = "assets"
  enable_versioning = true
  ec2_role_arn      = module.iam.ec2_role_arn
  common_tags       = local.common_tags
}

# ==============================================================
# EC2 Module — userdata loaded from .tpl file (Nginx)
# ==============================================================
module "ec2" {
  source = "../../modules/ec2"

  project_name          = var.project_name
  environment           = var.environment
  instance_type         = var.instance_type
  app_sg_id             = module.security_groups.app_sg_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  target_group_arns     = [module.alb.target_group_arn]
  instance_profile_name = module.iam.ec2_instance_profile_name
  s3_bucket_name        = module.s3.bucket_id
  db_host               = module.rds.db_instance_address
  asg_min               = var.asg_min
  asg_max               = var.asg_max
  asg_desired           = var.asg_desired
  common_tags           = local.common_tags
}
