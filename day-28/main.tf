provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my_new_vpc"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a" 
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-west-2b" 
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}

# ec2.tf

resource "aws_instance" "app_server" {  
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public-a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
  tags = {
    Name = "app_server"
  }
}

# rds.tf

resource "aws_db_instance" "mysql" {
  identifier        = "mydb"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  
  allocated_storage = 20
  
  publicly_accessible = false
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  db_subnet_group_name  = aws_db_subnet_group.main.name

  skip_final_snapshot = true

  tags = {
    Name = "mydb"
  }
}

resource "aws_db_subnet_group" "main" {
  name        = "main"
  subnet_ids   = [aws_subnet.public-a.id, aws_subnet.public-b.id]  
  tags = {
    Name = "db_subnet_group"
  }
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

resource "aws_s3_bucket" "static_assets" {
  bucket = "myalmostnewbuckettt"
  tags = {
    Name = "static_assets"
  }
} 