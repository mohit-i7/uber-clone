output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "rds_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.main.port
}

output "rds_username" {
  description = "The master username of the RDS instance"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "rds_password" {
  description = "The master password of the RDS instance"
  value       = aws_db_instance.main.password
  sensitive   = true
}

# Note: Replica outputs will be added back when the replica is re-enabled
# output "replica_endpoint" {
#   description = "The connection endpoint for the RDS read replica"
#   value       = aws_db_instance.replica.endpoint
# } 