output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_ec2_subnet_ids" {
  description = "The IDs of the private EC2 subnets"
  value       = module.networking.private_ec2_subnet_ids
}

output "private_rds_subnet_ids" {
  description = "The IDs of the private RDS subnets"
  value = {
    primary  = module.networking.private_rds_primary_subnet_id
    replica  = module.networking.private_rds_replica_subnet_id
  }
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.database.rds_endpoint
}

output "rds_port" {
  description = "The port of the RDS instance"
  value       = module.database.rds_port
}

output "rds_username" {
  description = "The master username of the RDS instance"
  value       = module.database.rds_username
  sensitive   = true
}

output "rds_password" {
  description = "The master password of the RDS instance"
  value       = module.database.rds_password
  sensitive   = true
}

# Note: Replica output will be added back when the replica is re-enabled
# output "replica_endpoint" {
#   description = "The connection endpoint for the RDS read replica"
#   value       = module.database.replica_endpoint
# } 