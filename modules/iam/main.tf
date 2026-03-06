# ============================================================
# Data Sources
# ============================================================
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ============================================================
# IAM Role for EC2 — assume role from .tpl
# ============================================================
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = templatefile("${path.module}/policies/ec2_assume_role.json.tpl", {
    aws_region = data.aws_region.current.name
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  })
}

# ============================================================
# S3 Access Policy — from .tpl
# ============================================================
resource "aws_iam_policy" "s3_access" {
  name        = "${var.project_name}-${var.environment}-s3-access"
  description = "S3 access policy for ${var.environment} EC2 instances"

  policy = templatefile("${path.module}/policies/s3_access_policy.json.tpl", {
    s3_bucket_name = var.s3_bucket_name
    environment    = var.environment
  })

  tags = var.common_tags
}

# ============================================================
# CloudWatch + SSM Policy — from .tpl
# ============================================================
resource "aws_iam_policy" "cloudwatch" {
  name        = "${var.project_name}-${var.environment}-cloudwatch"
  description = "CloudWatch and SSM policy for ${var.environment} EC2 instances"

  policy = templatefile("${path.module}/policies/cloudwatch_policy.json.tpl", {
    aws_region   = data.aws_region.current.name
    account_id   = data.aws_caller_identity.current.account_id
    project_name = var.project_name
    environment  = var.environment
  })

  tags = var.common_tags
}

# ============================================================
# Attach Policies to Role
# ============================================================
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch.arn
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ============================================================
# Instance Profile
# ============================================================
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = var.common_tags
}
