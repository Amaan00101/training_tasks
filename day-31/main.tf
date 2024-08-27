provider "aws" {
  region = var.aws_region
}

module "ec2" {
  source           = "./modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_public_a   = module.vpc.subnet_public_a
  vpc_id            = module.vpc.vpc_id
  aws_security_group = module.vpc.aws_security_group
}

module "iam" {
  source           = "./modules/iam"
  policy_arn       = var.policy_arn
}

module "rds" {
  source           = "./modules/rds"
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
  subnet_public_a   = module.vpc.subnet_public_a
  aws_security_group = module.vpc.aws_security_group
  subnet_public_b    = module.vpc.subnet_public_b
}

module "s3" {
  source           = "./modules/s3"
  bucket_name      = var.bucket_name
}

module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
}

