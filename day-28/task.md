### Project Objective

This project aims to assess the ability to deploy a multi-tier architecture application on AWS using Terraform. The architecture includes an EC2 instance, an RDS MySQL database instance, and an S3 bucket. Key elements include using Terraform variables, outputs, and change sets to manage and deploy the infrastructure.

### Project Overview

The infrastructure to be deployed consists of:

- **EC2 Instance**: A `t2.micro` instance serving as the application server.
- **RDS MySQL DB Instance**: A `t3.micro` instance for the database backend.
- **S3 Bucket**: For storing static assets or configuration files.

### Specifications

- **EC2 Instance**: Use `t2.micro` instance type with a public IP, allowing HTTP and SSH access.
- **RDS MySQL DB Instance**: Use `t3.micro` instance type with a publicly accessible endpoint.
- **S3 Bucket**: For storing static assets, configuration files, or backups.

### Terraform Configuration

#### Provider Configuration
- Configure the AWS provider with a parameterized region.
```
provider "aws" {
  region = var.aws_region
}
```


#### VPC and Security Groups
- Create a VPC with a public subnet for the EC2 instance.
```
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my_new_vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a" 
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}
```


- Define security groups allowing HTTP and SSH access to the EC2 instance, and MySQL access to the RDS instance.
```
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
```


#### EC2 Instance
- Define the EC2 instance with `t2.micro` type.
- Allow SSH and HTTP access.
- Use variables for instance parameters like AMI ID and instance type.
```
resource "aws_instance" "app_server" {  
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public-a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
  tags = {
    Name = "app_server"
  }
}
```


#### RDS MySQL DB Instance
- Create a `t3.micro` MySQL DB instance within the same VPC.
- Use variables for DB parameters like DB name, username, and password.
- Ensure the DB instance is publicly accessible and configure security groups for EC2 access.
```
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
```


#### S3 Bucket
- Create an S3 bucket for static files or configurations.
- Assign an IAM role and policy to allow EC2 instance access to the S3 bucket.
```
resource "aws_s3_bucket" "static_assets" {
  bucket = "myalmostnewbuckettt"
  tags = {
    Name = "static_assets"
  }
} 
```


#### Outputs
- Display important information including:
  - EC2 instance public IP address
  - RDS instance endpoint
  - S3 bucket name
```
output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}
```

#### Test Results: 
- Evidence of successful deployment and testing, including screenshots or command outputs.
- initializing deployment
```
terraform init
```

![alt text](<images/Screenshot from 2024-08-21 15-28-24.png>)
---


- Validate the setup by
- Check the Terraform outputs to ensure they correctly display the relevant information.
```
terraform plan
```

![alt text](<images/Screenshot from 2024-08-21 15-33-04.png>)
---


- apply deployment
```
terraform apply
```

![alt text](<images/Screenshot from 2024-08-21 16-23-27.png>)
![alt text](<images/Screenshot from 2024-08-21 16-23-11 copy.png>)
---


+ #### OutPut

![alt text](<images/Screenshot from 2024-08-21 16-33-22.png>)

![alt text](<images/Screenshot from 2024-08-21 16-38-19.png>)
---


#### Cleanup Confirmation:
- Once the deployment is complete and validated, run terraform destroy to tear down all the resources created by Terraform.
- Confirmation that all resources have been terminated using terraform destroy.
```
terraform destroy
```

![alt text](<images/Screenshot from 2024-08-21 16-40-51.png>)
![alt text](<images/Screenshot from 2024-08-21 17-02-24.png>)
---