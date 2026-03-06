output "ec2_role_arn" {
  description = "EC2 IAM Role ARN"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_role_name" {
  description = "EC2 IAM Role name"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_instance_profile_arn" {
  description = "EC2 Instance Profile ARN"
  value       = aws_iam_instance_profile.ec2_profile.arn
}

output "ec2_instance_profile_name" {
  description = "EC2 Instance Profile name"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "s3_access_policy_arn" {
  description = "S3 access policy ARN"
  value       = aws_iam_policy.s3_access.arn
}

output "cloudwatch_policy_arn" {
  description = "CloudWatch policy ARN"
  value       = aws_iam_policy.cloudwatch.arn
}
