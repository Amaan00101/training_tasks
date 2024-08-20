## Project Day - 27

### Project Objective
This project aims to test the ability to deploy a multi-tier architecture application using AWS CloudFormation. The deployment includes an EC2 instance, an S3 bucket, a MySQL DB instance in RDS, and a VPC, all within the specified constraints.

### Project Overview
The goal is to design and deploy a multi-tier application using AWS CloudFormation with the following components:
- **EC2 Instance**: Acts as the web server.
- **S3 Bucket**: Stores static assets or configuration files.
- **RDS MySQL DB Instance**: Serves as the database backend.
- **VPC**: Ensures secure communication between components.

### Specifications
- **EC2 Instance**:
  - Type: `t2.micro`
  - Location: Public subnet
  - Access: SSH allowed from a specific IP range

- **RDS MySQL DB Instance**:
  - Type: `t3.micro`
  - Location: Private subnet

- **S3 Bucket**:
  - Used for storing configuration files or assets for the web server

- **VPC**:
  - Create a VPC with one public and one private subnet
  - Attach an Internet Gateway to the VPC for public subnet access


### Key Tasks

#### 1. Create a CloudFormation Template

- **A complete template file (`.yaml` or `.json`) used for deployment.**

```
AWSTemplateFormatVersion: '2010-09-09'
Description: AWS CloudFormation Template to create a VPC, EC2 instance, RDS MySQL database, and S3 bucket without SSH access.

Parameters:
  VpcCidr:
    Type: String
    Default: 10.0.0.0/16
    Description: CIDR block for the VPC.

  PublicSubnetCidr:
    Type: String
    Default: 10.0.1.0/24
    Description: CIDR block for the public subnet.

  PrivateSubnetCidr:
    Type: String
    Default: 10.0.2.0/24
    Description: CIDR block for the private subnet.

  InstanceType:
    Type: String
    Default: t2.micro
    Description: EC2 instance type.

  KeyName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: Name of an existing EC2 KeyPair.

  DBUsername:
    Type: String
    Default: admin
    NoEcho: true
    Description: The database admin account username.

  DBPassword:
    Type: String
    NoEcho: true
    Description: The database admin account password.
    MinLength: 8
    MaxLength: 41
    AllowedPattern: '[a-zA-Z0-9]*'
    ConstraintDescription: Must contain only alphanumeric characters.

  DBAllocatedStorage:
    Type: Number
    Default: 20
    Description: The size of the database (Gb).

  AMIId:
    Type: String
    Description: The AMI ID for the EC2 instance.
    Default: 'ami-06e750e5fbe56c3ea'

  S3BucketName:
    Type: String
    Description: Unique name for the S3 bucket.

Resources:
  # VPC
  MyVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCidr
      EnableDnsSupport: 'true'
      EnableDnsHostnames: 'true'
      Tags:
        - Key: Name
          Value: MyVPC

  # Internet Gateway
  MyInternetGateway:
    Type: AWS::EC2::InternetGateway

  # Attach Internet Gateway to VPC
  AttachGateway:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref MyVPC
      InternetGatewayId: !Ref MyInternetGateway

  # Public Subnet
  PublicSubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: !Ref PublicSubnetCidr
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: 'true'
      Tags:
        - Key: Name
          Value: PublicSubnet

  # Private Subnet
  PrivateSubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: !Ref PrivateSubnetCidr
      AvailabilityZone: !Select [0, !GetAZs '']
      Tags:
        - Key: Name
          Value: PrivateSubnet

  # Private Subnet 2
  PrivateSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: 10.0.3.0/24  # Adjust the CIDR block for the second subnet
      AvailabilityZone: !Select [1, !GetAZs '']
      Tags:
        - Key: Name
          Value: PrivateSubnet2

  # Route Table for Public Subnet
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref MyVPC
      Tags:
        - Key: Name
          Value: PublicRouteTable

  # Route to Internet Gateway for Public Subnet
  PublicRoute:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref MyInternetGateway

  # Associate Public Subnet with Route Table
  PublicSubnetRouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet
      RouteTableId: !Ref PublicRouteTable

  # Security Group for EC2 instance
  EC2SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable HTTP access on the inbound.
      VpcId: !Ref MyVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: '80'
          ToPort: '80'
          CidrIp: 0.0.0.0/0

  # Security Group for RDS instance
  RDSSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow MySQL access only from the EC2 instance.
      VpcId: !Ref MyVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: '3306'
          ToPort: '3306'
          SourceSecurityGroupId: !Ref EC2SecurityGroup

  # EC2 Instance
  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !Ref InstanceType
      KeyName: !Ref KeyName
      SecurityGroupIds:
        - !Ref EC2SecurityGroup
      SubnetId: !Ref PublicSubnet
      # IamInstanceProfile: !Ref EC2InstanceProfile
      ImageId: !Ref AMIId
      UserData: !Base64
        Fn::Sub: |
          #!/bin/bash
          apt update -y
          apt install -y apache2 mysql-client
          systemctl start apache2
          systemctl enable apache2

  # S3 Bucket
  MyS3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Ref S3BucketName


  # RDS MySQL DB Instance
  MyRDSInstance:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceClass: db.t3.micro
      Engine: MySQL
      MasterUsername: !Ref DBUsername
      MasterUserPassword: !Ref DBPassword
      AllocatedStorage: !Ref DBAllocatedStorage
      DBSubnetGroupName: !Ref DBSubnetGroup
      VPCSecurityGroups:
        - !Ref RDSSecurityGroup

  # DB Subnet Group
  DBSubnetGroup:
    Type: AWS::RDS::DBSubnetGroup
    Properties:
      DBSubnetGroupDescription: Subnet group for RDS
      SubnetIds:
        - !Ref PrivateSubnet
        - !Ref PrivateSubnet2
```


- **VPC and Subnets**:
  - Define a VPC with one public and one private subnet.
  - Attach an Internet Gateway to the VPC for public subnet access.

![alt text](<images/Screenshot from 2024-08-20 15-50-51.png>)
---


- **Security Groups**:
  - Create a security group for the EC2 instance, allowing SSH and HTTP access from a specific IP range.
  - Create a security group for the RDS instance, allowing MySQL access from the EC2 instance only.

![alt text](<images/Screenshot from 2024-08-20 15-51-04.png>)
---


- **EC2 Instance**:
  - Launch a `t2.micro` EC2 instance in the public subnet.
  - Configure the instance to access the S3 bucket and connect to the RDS instance.

![alt text](<images/Screenshot from 2024-08-20 15-54-53.png>)
---


- **S3 Bucket**:
  - Create an S3 bucket for storing static assets or configuration files.
  - Ensure the EC2 instance has the necessary IAM role and permissions to access the S3 bucket.

![alt text](<images/Screenshot from 2024-08-20 15-51-26.png>)
---


- **RDS MySQL DB Instance**:
  - Launch a `t3.micro` MySQL database in the private subnet.
  - Configure the security group to allow access only from the EC2 instance.

![alt text](<images/Screenshot from 2024-08-20 15-51-55.png>)
---


#### 2. Deploy the Application
- Deploy the CloudFormation stack using the template created.
- Verify that all components are correctly configured and operational.
- Ensure the EC2 instance can communicate with the RDS instance and access the S3 bucket.

![alt text](<images/Screenshot from 2024-08-20 15-36-45.png>)
![alt text](<images/Screenshot from 2024-08-20 15-39-36.png>)
![alt text](<images/Screenshot from 2024-08-20 15-40-17.png>)
---


#### 3. Resource Termination
- Once deployment and testing are complete, terminate all resources by deleting the CloudFormation stack.
- Ensure that no resources, such as EC2 instances, RDS instances, or S3 buckets, are left running.

![alt text](<images/Screenshot from 2024-08-20 16-03-28.png>)
![alt text](<images/Screenshot from 2024-08-20 16-09-02.png>)