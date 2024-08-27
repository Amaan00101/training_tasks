### Project Objective:

This project will test your skills in using Terraform modules, functions, variables, state locks, and remote state management. The project requires deploying infrastructure on AWS using a custom Terraform module and managing the state remotely in an S3 bucket, while testing the locking mechanism with DynamoDB. Participants will also configure variables and outputs using functions.


### Project Overview:

You will create a Terraform configuration that uses a custom module to deploy a multi-component infrastructure on AWS. The state files will be stored remotely in an S3 bucket, and DynamoDB will handle state locking. Additionally, the project will involve creating a flexible and reusable Terraform module, using input variables (tfvars) and Terraform functions to parameterize configurations.


## Key Components

### 1. Remote State Management

**S3 Bucket for State:**
- The state files are stored remotely in an S3 bucket to manage state across different environments.
```
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-bucketttt-ismine"

  tags = {
    Name = "Amaan Bucket"
  }
}
```


**State Locking with DynamoDB:**
- DynamoDB table is used to lock the state file and prevent concurrent modifications.
```
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "Amaan-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "State Lock Table"
  }
}
```


- Configure s3 & DynamoDB table in `backend.tf`.
```
terraform {
  backend "s3" {
    bucket         = "terraform-bucketttt-ismine" 
    key            = "terraform/state.tfstate"
    region         = "us-east-2" 
    encrypt        = true
    dynamodb_table = "Amaan-locks" 
  }
}
```


### 2. Terraform Module Creation

**Module:**
- The module ec2 and s3 deploys:
  - An EC2 instance with configurable instance type and SSH access.
  - An S3 bucket with a configurable name.
```
resource "aws_instance" "my_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = join("-", [var.instance_name, "server"])
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = join("-", [var.bucket_name, "bucket"])
  }
}
```


### 3. Input Variables and Configuration

**Variables:**
- EC2 instance type.
- S3 bucket name.
- AWS region.
```
variable "bucket" {
    type = string
    default = "myy-terraform-bucket"
}

variable "instance_name" {
    type = string
    default = "Amaan-new-inst"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "region" {
    type = string
    default = "region"
}
```


### 4. Testing

**1. Initialize Terraform:**
```bash
terraform init
```
![alt text](<images/Screenshot from 2024-08-22 11-13-25.png>)
---


**2. Plan Infrastructure Deployment:**
```bash
terraform plan
```
![alt text](<images/Screenshot from 2024-08-22 11-28-15.png>)
---


**3. Apply Infrastructure Changes:**
```bash
terraform apply
```
![alt text](<images/Screenshot from 2024-08-22 11-29-46.png>)
![alt text](<images/Screenshot from 2024-08-22 11-37-05.png>)
---


**4. Remote State Management:**
- Verify that the state file is updated in the S3 bucket and check state locking with DynamoDB.

![alt text](<images/Screenshot from 2024-08-22 11-38-18.png>)
---


**5. Outputs**

Outputs include:
- EC2 Instance

![alt text](<images/Screenshot from 2024-08-22 11-37-36.png>)


- S3 Bucket Name

![alt text](<images/Screenshot from 2024-08-22 11-38-35.png>)


- DynamoDB Table

![alt text](<images/Screenshot from 2024-08-22 11-39-12.png>)


5. **Destroy Infrastructure:**
- Use `terraform destroy` to tear down all resources.
```bash
terraform destroy
```

![alt text](<images/Screenshot from 2024-08-22 11-43-34.png>)
---