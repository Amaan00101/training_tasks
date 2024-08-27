variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

resource "aws_subnet" "public-a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a" 
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

variable "subnet_public_a" {
  type        = string
}

variable "vpc_id" {
  
}

variable "aws_security_group" {
  type        = string
}