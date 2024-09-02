## ECS Fargate Web Application Deployment

### Project Overview

This project involves setting up an AWS ECS (Elastic Container Service) Cluster using the Fargate launch type to deploy a web application consisting of frontend and backend containers. The deployment includes configuring networking, security, scaling, and monitoring, as well as managing secrets and ensuring resource cleanup.

### Project Objectives

1. **ECS Cluster Setup**: Create an ECS Cluster using the Fargate launch type.
2. **Task Definitions**: Define task definitions for frontend and backend services.
3. **Services**: Deploy the frontend and backend services without using a Load Balancer or API Gateway.
4. **Security**: Configure security groups, IAM roles, and manage secrets for secure communication.
5. **Networking**: Set up VPC with public and private subnets.
6. **Scaling and Monitoring**: Implement auto-scaling policies and monitoring.

## Project Requirements


#### 1. VPC and Networking
+ Creates a VPC with public and private subnets.
+ Configures an Internet Gateway for public subnet access. alt text

![alt text](<images/Screenshot from 2024-09-02 17-28-20.png>)
---


#### 2. RDS Instance
+ Launches an RDS MySQL instance in a private subnet.
+ Stores database credentials (password) in plaintext within the configuration (consider using AWS Secrets Manager or SSM Parameter Store in production). alt text

![alt text](<images/Screenshot from 2024-09-02 17-29-27.png>)
---


#### 3. ECS Cluster and Services
+ Creates an ECS Cluster with Fargate launch type. alt text alt text

![alt text](<images/Screenshot from 2024-09-02 17-30-29.png>)
---


#### 4. IAM Roles
+ Defines IAM roles and policies for ECS task execution and task roles. alt text

![alt text](<images/Screenshot from 2024-09-02 17-38-22.png>)
---


#### 5. **Networking and Security**: 
+ Public subnets for frontend, private subnets for backend and RDS.
+ Security groups and IAM roles for task communication and security.

![alt text](<images/Screenshot from 2024-09-02 17-55-22.png>)
---


#### 6. Auto-Scaling Policies
+ Configures auto-scaling for frontend and backend services based on CPU and memory usage.

![alt text](<images/Screenshot from 2024-09-02 17-30-47.png>)
---

#### 7. **Deployment and Validation**: 
+ Deploy and test the application.
+ Initialize the Terraform working directory:
```
terraform init
```
![alt text](<images/Screenshot from 2024-09-02 17-20-10.png>)
---


+ Plan the Deployment
```
terraform plan 
```
![alt text](<images/Screenshot from 2024-09-02 17-20-27.png>)
---


+ Apply the Terraform configuration to deploy the infrastructure:
```
terraform apply
```
![alt text](<images/Screenshot from 2024-09-02 17-21-37.png>)
![alt text](<images/Screenshot from 2024-09-02 17-21-50.png>)
---


#### 8. **Resource Cleanup**: 
+ Clean up all resources post-validation.
+ To delete all the resources created by Terraform
```
terraform destroy
```
![alt text](<images/Screenshot from 2024-09-02 18-27-48.png>)
![alt text](<images/Screenshot from 2024-09-02 18-28-08.png>)
---