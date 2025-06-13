variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "db_instance_type" {
  description = "The instance type for RDS instances"
  type        = string
  default     = "db.t3.micro"
}

variable "db_storage_size" {
  description = "The allocated storage size for RDS in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "uberclone"
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "private_rds_primary_subnet_id" {
  description = "The ID of the primary private RDS subnet"
  type        = string
}

variable "private_rds_replica_subnet_id" {
  description = "The ID of the replica private RDS subnet"
  type        = string
}

variable "rds_security_group_id" {
  description = "The ID of the RDS security group"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 