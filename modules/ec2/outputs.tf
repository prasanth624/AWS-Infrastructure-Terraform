output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.app.id
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.app.name
}

output "asg_arn" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.app.arn
}

output "key_pair_name" {
  description = "Key pair name"
  value       = aws_key_pair.main.key_name
}

output "private_key_pem" {
  description = "Private key PEM (save securely)"
  value       = tls_private_key.main.private_key_pem
  sensitive   = true
}
