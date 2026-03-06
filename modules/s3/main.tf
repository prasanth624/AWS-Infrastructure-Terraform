# ============================================================
# Data Sources
# ============================================================
data "aws_caller_identity" "current" {}

# ============================================================
# S3 Bucket
# ============================================================
resource "aws_s3_bucket" "main" {
  bucket        = "${var.project_name}-${var.environment}-${var.bucket_suffix}"
  force_destroy = var.environment != "prod" ? true : false

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-${var.bucket_suffix}"
  })
}

# ============================================================
# Versioning
# ============================================================
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# ============================================================
# Server-Side Encryption
# ============================================================
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# ============================================================
# Block Public Access
# ============================================================
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================================
# Bucket Policy — loaded from .tpl
# ============================================================
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = templatefile("${path.module}/policies/bucket_policy.json.tpl", {
    bucket_name  = aws_s3_bucket.main.id
    ec2_role_arn = var.ec2_role_arn
    environment  = var.environment
    account_id   = data.aws_caller_identity.current.account_id
  })

  depends_on = [aws_s3_bucket_public_access_block.main]
}

# ============================================================
# Lifecycle Rules
# ============================================================
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "transition-to-ia"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }

  depends_on = [aws_s3_bucket_versioning.main]
}
