variable "aws_region" {
  default = "us-east-1"
}

variable "bucket" {
  type = string
  default = "myy-neww-bucket"
}

variable "instance_name" {
  type = string
  default = "myy-neww-inst"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "private_key_path" {
  type = string
}

