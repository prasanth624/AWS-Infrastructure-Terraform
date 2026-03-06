# ==============================================================
# Outputs
# ==============================================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name — access your app here"
  value       = "http://${module.alb.alb_dns_name}"
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_instance_endpoint
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_id
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.ec2.asg_name
}

output "nat_gateway_ip" {
  description = "NAT Gateway public IP"
  value       = module.vpc.nat_gateway_public_ip
}

output "private_key_command" {
  description = "Command to save the SSH private key"
  value       = "terraform output -raw private_key_pem > ${var.project_name}-${var.environment}.pem && chmod 400 ${var.project_name}-${var.environment}.pem"
}

output "private_key_pem" {
  description = "SSH private key"
  value       = module.ec2.private_key_pem
  sensitive   = true
}
