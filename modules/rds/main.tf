# ============================================================
# Random password for DB
# ============================================================
resource "random_password" "db_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ============================================================
# DB Subnet Group
# ============================================================
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet"
  })
}

# ============================================================
# RDS PostgreSQL Instance
# ============================================================
resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-${var.environment}-db"
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.database_name
  username = var.database_username
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]

  multi_az            = var.multi_az
  publicly_accessible = false

  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  skip_final_snapshot       = var.environment != "prod"
  final_snapshot_identifier = var.environment == "prod" ? "${var.project_name}-${var.environment}-final-snapshot" : null
  deletion_protection       = var.environment == "prod"

  performance_insights_enabled = var.environment == "prod"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-db"
  })
}

# ============================================================
# Store password in SSM Parameter Store
# ============================================================
resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.project_name}/${var.environment}/db/password"
  description = "RDS database password"
  type        = "SecureString"
  value       = random_password.db_password.result

  tags = var.common_tags
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/${var.project_name}/${var.environment}/db/host"
  description = "RDS database host"
  type        = "String"
  value       = aws_db_instance.main.address

  tags = var.common_tags
}

resource "aws_ssm_parameter" "db_connection_string" {
  name        = "/${var.project_name}/${var.environment}/db/connection_string"
  description = "RDS database connection string"
  type        = "SecureString"
  value       = "postgresql://${var.database_username}:${random_password.db_password.result}@${aws_db_instance.main.endpoint}/${var.database_name}"

  tags = var.common_tags
}
