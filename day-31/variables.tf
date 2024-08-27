variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "aws_region" {
  description = "The region for instance."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "ami id"
  type        = string
}

variable "db_name" {
  description = "The name of the database."
  type        = string
}

variable "db_username" {
  description = "The database username."
  type        = string
}

variable "db_password" {
  description = "The database password."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "policy_arn" {
  description = "iam policy arn."
  type        = string
}
