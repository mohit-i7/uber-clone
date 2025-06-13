variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "The instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for EC2 instances"
  type        = string
  default     = "ap-south-1-ec2-key"
}

variable "allowed_ssh_ip" {
  description = "The IP address allowed to SSH into EC2 instances"
  type        = string
  default     = "0.0.0.0/0"  # Note: In production, this should be restricted
}

variable "asg_desired_capacity" {
  description = "The desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
  default     = 4
}

variable "asg_min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
  default     = 2
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
  default     = "uberadmin"  # Changed from 'admin' as it's a reserved word in PostgreSQL
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  default     = "uberadmin"  # Secure password with uppercase, lowercase, numbers, and special character
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "uber-clone"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
} 