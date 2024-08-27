## Advanced Terraform Project: Provisioners, Modules, and Workspaces

### Project Objective
This project is designed to evaluate understanding of Terraform provisioners, modules, and workspaces. It involves deploying infrastructure on AWS using Terraform modules, executing remote commands on the provisioned resources with provisioners, and managing multiple environments using Terraform workspaces.

### Project Overview
Participants will:
- Create a reusable Terraform module to deploy an EC2 instance and an S3 bucket.
- Use provisioners to install Apache on the EC2 instance and output deployment status locally.
- Manage separate environments using Terraform workspaces for `dev` and `prod`.

## Specifications

### Terraform Modules
- **Module Directory**: `modules/infra`
- **Resources**:
  - EC2 Instance (`t2.micro` type)
  - S3 Bucket (standard storage)

- **Input Variables**:
  - `instance_type`: Type of EC2 instance
  - `ami_id`: AMI ID for the EC2 instance
  - `key_pair_name`: Name of the SSH key pair
  - `bucket_name`: Name of the S3 bucket

- **Outputs**:
  - `instance_public_ip`: Public IP address of the EC2 instance
  - `bucket_arn`: ARN of the S3 bucket

### Terraform Provisioners
- **Remote-Exec Provisioner**:
  - Install Apache HTTP Server on the EC2 instance.
- **Local-Exec Provisioner**:
  - Output a message on the local machine indicating successful deployment.

### Terraform Workspaces
- **Workspaces**:
  - `dev`: Development environment
  - `prod`: Production environment
- **Configurations**:
  - Different tags and bucket names for each workspace
- **Deployment**:
  - Manage and deploy infrastructure separately for each workspace.

## Key Tasks

### Module Development
1. **Module Setup**: Create a directory `modules/aws_infrastructure`.
```
├── main.tf
├── modules
│   └── infra
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
```
![alt text](<images/Screenshot from 2024-08-26 16-33-19.png>)
---


2. **Resource Definitions**: Define an EC2 instance and an S3 bucket.
```
resource "aws_instance" "my-neww-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
}

resource "aws_s3_bucket" "my_buckett" {
  bucket = var.bucket_name
}
```


3. **Variable Inputs**: Define variables for instance type, AMI ID, key pair name, and bucket name.
```
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key for SSH access"
  type        = string
}
```


4. **Outputs**: Define outputs for the EC2 instance’s public IP and the S3 bucket’s ARN.
```
output "infra_instance_id" {
  value = module.infra.instance_id
}

output "infra_bucket_name" {
  value = module.infra.bucket_name
}
```


### Main Terraform Configuration
1. **Main Config Setup**: Create a Terraform configuration in the root directory calling the custom module.
2. **Backend Configuration**: Optionally configure Terraform for local state storage.

### Provisioner Implementation
1. **Remote Execution**:
   - Use `remote-exec` to install Apache on the EC2 instance.
```
provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2.service",
      "sudo systemctl enable apache2.service"
    ]
  }

connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/einfochips/Downloads/SPkey.pem")
    host        = self.public_ip
  }
```

2. **Local Execution**:
   - Use `local-exec` to print a confirmation message on the local machine.
```
provisioner "local-exec" {
    command = "echo EC2 instance has been Deployed."
}
```

+ Initialize Terraform

![alt text](<images/Screenshot from 2024-08-22 18-41-14.png>)
---


### Workspace Management
1. **Workspace Creation**: Create `dev` and `prod` workspaces.
2. **Environment-Specific Configurations**: Customize configurations for each workspace.
3. **Workspace Deployment**: Deploy infrastructure separately for each workspace.

+ Create and switch to the dev workspace:
+ Deploy the infrastructure in the dev workspace:
```
terraform workspace new dev
terraform apply -auto-approve
```
![alt text](<images/Screenshot from 2024-08-23 15-43-31.png>)
---


+ Create and switch to the prod workspace:
+ Deploy the infrastructure in the prod workspace:
```
terraform workspace new prod
terraform apply -auto-approve
```
![alt text](<images/Screenshot from 2024-08-23 15-45-03.png>)
---


### Validation and Testing
1. **Apache Installation Verification**: Verify Apache is installed by accessing the EC2 instance’s public IP.
2. **Workspace Separation**: Confirm isolated infrastructure and state files for each workspace.
3. **Provisioner Logs**: Review logs for successful execution.

![alt text](<images/Screenshot from 2024-08-26 16-52-23.png>)


### Resource Cleanup
1. **Destroy Resources**: Use `terraform destroy` to remove resources in all workspaces.
2. **Workspace Management**: Confirm resources are destroyed and state files are updated.

![alt text](<images/Screenshot from 2024-08-23 15-49-21.png>)

![alt text](<images/Screenshot from 2024-08-23 15-47-39.png>)
---
