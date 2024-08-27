provider "aws" {
  region = var.aws_region
}

module "infra" {
  source           = "./modules/infra"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  instance_name     = var.instance_name
  key_name          = var.key_name
  bucket_name       = var.bucket_name
  private_key_path  = var.private_key_path
}
