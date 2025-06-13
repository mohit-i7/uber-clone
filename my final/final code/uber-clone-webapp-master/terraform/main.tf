terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  tags        = var.tags
}

# Security Module
module "security" {
  source = "./modules/security"

  vpc_id          = module.networking.vpc_id
  environment     = var.environment
  allowed_ssh_ip  = var.allowed_ssh_ip
  tags            = var.tags

  depends_on = [module.networking]
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  vpc_id                    = module.networking.vpc_id
  environment               = var.environment
  instance_type             = var.instance_type
  key_name                  = var.key_name
  public_web_primary_subnet_id    = module.networking.public_subnet_ids[0]
  public_web_replica_subnet_id    = module.networking.public_subnet_ids[1]
  private_app_primary_subnet_id   = module.networking.private_ec2_subnet_ids[0]
  private_app_replica_subnet_id   = module.networking.private_ec2_subnet_ids[1]
  alb_security_group_id     = module.security.alb_security_group_id
  ec2_security_group_id     = module.security.ec2_security_group_id
  ec2_instance_profile_name = module.security.ec2_instance_profile_name
  asg_desired_capacity      = var.asg_desired_capacity
  asg_max_size              = var.asg_max_size
  asg_min_size              = var.asg_min_size
  tags                      = var.tags

  depends_on = [module.networking, module.security]
}

# Database Module
module "database" {
  source = "./modules/database"

  environment                    = var.environment
  db_instance_type              = var.db_instance_type
  db_storage_size              = var.db_storage_size
  db_name                      = var.db_name
  db_username                  = var.db_username
  db_password                  = var.db_password
  private_rds_primary_subnet_id = module.networking.private_rds_primary_subnet_id
  private_rds_replica_subnet_id = module.networking.private_rds_replica_subnet_id
  rds_security_group_id        = module.security.rds_security_group_id
  tags                         = var.tags

  depends_on = [module.networking, module.security]
} 