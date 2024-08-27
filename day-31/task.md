## Automation (IaaC) Terraform on AWS Assessment Project

### Project Overview
This capstone project assesses your skills in using Terraform to deploy a complete infrastructure on AWS. The project focuses on state management, variables, modules, workspaces, and lifecycle rules. You will deploy a multi-tier web application architecture using Terraform and ensure all resources are within AWS Free Tier limits.

### Project Objectives
- Deploy a multi-tier architecture on AWS.
- Implement state locking for managing concurrent changes.
- Use variables and `.tfvars` files for parameterization.
- Create reusable Terraform modules.
- Utilize Terraform functions for dynamic resource configuration.
- Manage multiple environments with Terraform workspaces.
- Implement lifecycle rules to control resource management.

## Project Requirements

#### 1. Infrastructure Design
Deploy a 3-tier web application architecture with the following components:
- **VPC**: Create a VPC with public and private subnets across two availability zones.
- **Security Groups**: Define security groups for controlling traffic.
- **EC2 Instances**: Deploy EC2 instances in public subnets for the application tier.
- **RDS Instance**: Deploy an RDS MySQL instance in the private subnet.
- **S3 Bucket**: Create an S3 bucket with versioning enabled.
- **Elastic IPs**: Assign Elastic IPs to EC2 instances.
- **IAM Role**: Create an IAM role with necessary permissions and attach it to EC2 instances.

#### 2. Terraform State Management
- **Remote State Storage**: Use an S3 bucket for storing the Terraform state file.
- **State Locking**: Use DynamoDB for state locking to prevent concurrent modifications.

#### 3. Variables and `.tfvars`
- **Variables**: Define variables for VPC CIDR, instance types, database credentials, and S3 bucket names.
- **.tfvars Files**: Use `.tfvars` files to pass configurations for different environments (e.g., `dev.tfvars`, `prod.tfvars`).

#### 4. Modules
- **VPC Module**: Manage VPC, subnets, and routing tables.
- **EC2 Module**: Configure and launch EC2 instances.
- **RDS Module**: Set up the RDS MySQL database.
- **S3 Module**: Create and manage S3 buckets with versioning.
- **IAM Module**: Create and manage IAM roles and policies.

#### 5. Functions
- **Dynamic Configuration**: Use functions to configure:
  - Resource names using `format` and `join`.
  - Subnet CIDRs using `cidrsubnet`.
  - AMI IDs using the `lookup` function.

#### 6. Workspaces
- **Workspaces**: Create workspaces for `development`, `staging`, and `production`.
- **Deployment**: Deploy infrastructure in each environment using appropriate `.tfvars` files.

#### 7. Lifecycle Rules
- **Prevent Resource Deletion**: Use `prevent_destroy` to protect critical resources.
- **Ignore Attribute Changes**: Use `ignore_changes` to ignore changes to specific resource attributes.

### Project Steps

### Step 1: Setup Remote State and Locking
1. Create an S3 bucket for Terraform state.
2. Create a DynamoDB table for state locking.
3. Configure the Terraform backend to use S3 and DynamoDB.
```
provider "aws" {
  region  = var.aws_region
  profile = "default"
}
resource "aws_s3_bucket" "static_assets" {
  bucket = var.bucket_name
  tags = {
    Name = "static_assets"
  }
}


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


### Step 2: Develop and Organize Modules
1. Create modules for VPC, EC2, RDS, S3, and IAM.
2. Place each module in a separate directory with `main.tf`, `variables.tf`, and `outputs.tf`.

![alt text](<images/Screenshot from 2024-08-26 20-29-28.png>)
---

+ For EC2

`**modules/ec2/main.tf**`
```
resource "aws_instance" "app_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = "myy-us-east-1"
  subnet_id                   = var.subnet_public_a
  vpc_security_group_ids      = [var.aws_security_group]
  associate_public_ip_address = true
  tags = {
    Name = "myyy-AppServer"
  }
  lifecycle {
    prevent_destroy = true
  }
}
```

`**modules/ec2/varibales.tf**`

```
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "subnet_public_a" {
  type        = string
}

variable "vpc_id" {
  
}

variable "aws_security_group" {
  type        = string
}
```

+ For IAM

`**modules/IAM/main.tf**`
```
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = var.policy_arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_inst_profile"
  role = aws_iam_role.ec2_role.name
}
```

`**modules/IAM/variables.tf**`
```
variable "policy_arn" {
  description = "iam policy arn."
  type        = string
}
```


`**modules/IAM/outputs.tf**`
```
output "iam_role_name" {
  value       = aws_iam_role.ec2_role.name
}

output "iam_instance_profile_name" {
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "role_arn" {
  value = aws_iam_role.ec2_role.arn
}
```

+ For RDS

`**modules/rds/main.tf**`
```
resource "aws_db_instance" "mysql" {
  identifier        = "mydb"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  
  publicly_accessible = false
  
  vpc_security_group_ids = [var.aws_security_group]
  
  db_subnet_group_name  = aws_db_subnet_group.main.name

  skip_final_snapshot = true

  tags = {
    Name = "mydb"
  }
}

resource "aws_db_subnet_group" "main" {
  name        = "main"
  subnet_ids   = [var.subnet_public_a, var.subnet_public_b]  
  tags = {
    Name = "db_subnet_group"
  }
}
```

`**modules/rds/varibales.tf**`
```
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

variable "subnet_public_a" {

}

variable "aws_security_group" {
  
}


variable "subnet_public_b" {
  
}
```


### Step 3: Define Variables and `.tfvars` Files
1. Define variables in `variables.tf` within each module.
2. Create a `terraform.tfvars` file with default values.
3. Create environment-specific `.tfvars` files (e.g., `dev.tfvars`, `prod.tfvars`).

```
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
```


### Step 4: Implement Workspaces
1. Initialize Terraform and create workspaces (`development`, `staging`, `production`).
```
terraform workspace new dev
terraform workspace new prod
```

2. Deploy infrastructure using the appropriate `.tfvars` file for each workspace.
```
terraform workspace select dev
terraform apply -var-file=dev.tfvars -var="aws_profile=dev"
```
```
terraform workspace select prod
terraform apply -var-file=prod.tfvars -var="aws_profile=prod"
```


### Step 5: Deploy the Infrastructure
1. Use `terraform apply` to deploy the infrastructure in each workspace.

![alt text](<images/Screenshot from 2024-08-26 12-24-39.png>)
![alt text](<images/Screenshot from 2024-08-26 15-08-34.png>)
![alt text](<images/Screenshot from 2024-08-26 16-04-11.png>)
---


2. Verify the deployment by checking EC2 instances and ensuring the application is running.

![alt text](<images/Screenshot from 2024-08-26 16-04-41.png>)
---


## Output

![text](<images/Screenshot from 2024-08-26 16-05-34.png>) 

![text](<images/Screenshot from 2024-08-26 16-08-16.png>) 

![text](<images/Screenshot from 2024-08-26 16-11-17.png>) 

![text](<images/Screenshot from 2024-08-26 16-12-48.png>) 

![text](<images/Screenshot from 2024-08-26 16-14-19.png>) 

![text](<images/Screenshot from 2024-08-26 16-14-53.png>) 

![text](<images/Screenshot from 2024-08-26 16-15-43.png>) 

![text](<images/Screenshot from 2024-08-26 16-16-23.png>)
---


### Step 6: Implement Lifecycle Rules
1. Add lifecycle rules to your Terraform code.
2. Apply changes and verify lifecycle rules are in effect.

### Step 7: Cleanup
1. Destroy the infrastructure in each workspace using `terraform destroy`.
2. Ensure resources marked with `prevent_destroy` are not deleted.

![alt text](<images/Screenshot from 2024-08-26 17-05-11.png>)

![alt text](<images/Screenshot from 2024-08-26 20-24-43.png>)

![alt text](<images/Screenshot from 2024-08-26 17-14-57.png>)
---