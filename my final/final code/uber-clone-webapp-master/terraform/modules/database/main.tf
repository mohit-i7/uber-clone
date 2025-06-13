# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = [var.private_rds_primary_subnet_id, var.private_rds_replica_subnet_id]

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-db-subnet-group"
    }
  )
}

# RDS Parameter Group
resource "aws_db_parameter_group" "main" {
  name   = "${var.environment}-db-params"
  family = "postgres17"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-db-params"
    }
  )
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier             = "${var.environment}-db"
  engine                 = "postgres"
  engine_version         = "17.4"
  instance_class         = var.db_instance_type
  allocated_storage      = var.db_storage_size
  storage_type           = "gp2"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.main.name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot    = true
  backup_retention_period = 7
  multi_az              = false
  deletion_protection   = false

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-db"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# RDS Read Replica
resource "aws_db_instance" "replica" {
  identifier             = "${var.environment}-db-replica"
  replicate_source_db    = aws_db_instance.main.arn
  instance_class         = var.db_instance_type
  allocated_storage      = var.db_storage_size
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot    = true
  backup_retention_period = 0
  multi_az              = false
  deletion_protection   = false

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-db-replica"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Note: Read replica will be added back after primary instance is stable
# This is a temporary removal to resolve replication issues 