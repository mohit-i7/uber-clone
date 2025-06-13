output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_ec2_subnet_ids" {
  description = "The IDs of the private EC2 subnets"
  value       = aws_subnet.private_ec2[*].id
}

output "private_rds_primary_subnet_id" {
  description = "The ID of the primary private RDS subnet"
  value       = aws_subnet.private_rds_primary.id
}

output "private_rds_replica_subnet_id" {
  description = "The ID of the replica private RDS subnet"
  value       = aws_subnet.private_rds_replica.id
}

output "nat_gateway_ips" {
  description = "The public IP addresses of the NAT Gateways"
  value       = aws_nat_gateway.main[*].public_ip
} 