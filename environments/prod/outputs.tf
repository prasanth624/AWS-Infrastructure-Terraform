output "vpc_id" { value = module.vpc.vpc_id }
output "alb_dns_name" { value = "http://${module.alb.alb_dns_name}" }
output "rds_endpoint" { value = module.rds.db_instance_endpoint }
output "s3_bucket_name" { value = module.s3.bucket_id }
output "asg_name" { value = module.ec2.asg_name }
output "nat_gateway_ip" { value = module.vpc.nat_gateway_public_ip }
output "private_key_pem" { value = module.ec2.private_key_pem; sensitive = true }
