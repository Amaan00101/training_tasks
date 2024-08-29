## Multi-Tier Application Deployment Using Helm and AWS

### Overview

This guide outlines the process to deploy a multi-tier application on Minikube using Helm. The application consists of a frontend service served by Nginx and a backend service connected to an AWS RDS MySQL instance. We will also cover integrating AWS S3 for static file storage, managing Helm charts, handling secrets, and implementing RBAC.

## Project Objectives

1. Deploy a multi-tier application using Helm on Minikube.
2. Integrate AWS free-tier services (S3 and RDS).
3. Manage Helm charts, including versioning, packaging, and rollbacks.
4. Implement Helm secrets management and RBAC.
5. Handle dependencies between different components of the application.

### AWS Services Setup

### 1. Create an S3 Bucket

Create an S3 bucket to store static files for your frontend service:

```sh
aws s3api create-bucket --bucket your-bucket-name --region us-east-1
```
![alt text](<images/Screenshot from 2024-08-29 10-48-04.png>)

![alt text](<images/Screenshot from 2024-08-29 12-02-23.png>)
---


Upload your static files to the S3 bucket:

```sh
aws s3 cp /path/to/static/files/ s3://your-bucket-name/ --recursive
```
![alt text](<images/Screenshot from 2024-08-29 12-01-51.png>)
---


### 2. Set Up an RDS MySQL Instance

Create an RDS MySQL instance using the AWS CLI:

```sh
aws rds create-db-instance \
    --db-instance-identifier mydbinstance \
    --allocated-storage 20 \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password password123 \
    --backup-retention-period 7 \
    --availability-zone us-east-1a \
    --no-multi-az \
    --engine-version 8.0 \
    --auto-minor-version-upgrade \
    --publicly-accessible \
    --storage-type gp2 \
    --db-name mydatabase \
    --region us-east-1
```
![alt text](<images/Screenshot from 2024-08-29 12-23-16.png>)

![alt text](<images/Screenshot from 2024-08-29 12-18-55.png>)
---


Make a note of the DBInstanceIdentifier, Endpoint, Port, DBName, MasterUsername, and MasterUserPassword for use in Helm chart configuration.

## Create Helm Charts

### 1. Frontend Helm Chart

start Minikube and check status
```
minikube start
minikube status
```
![alt text](<images/Screenshot from 2024-08-29 12-27-48.png>)
---


Create a Helm chart for the frontend:

```sh
helm create frontend
```
![alt text](<images/Screenshot from 2024-08-29 12-33-34.png>)
---


Modify the `frontend/values.yaml` file:

```yaml
replicaCount: 1

image:
  repository: nginx
  tag: stable
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false

resources: {}

nodeSelector: {}

tolerations: []

affinity: []

files:
  staticUrl: "http://your-bucket-name.s3.amazonaws.com/"
```


Update `frontend/templates/deployment.yaml` to configure NGINX to pull static files from the S3 bucket.

### 2. Backend Helm Chart

Create a Helm chart for the backend:

```sh
helm create backend
```
![alt text](<images/Screenshot from 2024-08-29 12-39-35.png>)
---


Modify the `backend/values.yaml` file:

```yaml
replicaCount: 1

image:
  repository: your-backend-image
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 5000

ingress:
  enabled: false

resources: {}

nodeSelector: {}

tolerations: []

affinity: []

database:
  host: "your-rds-endpoint"
  name: "your-bucket-name"
  user: "admin"
  password: "your-password"
  port: 3306
```

Update `backend/templates/deployment.yaml` to connect to the RDS MySQL instance.

## Package Helm Charts

Navigate to each chart directory and package them:

```sh
cd frontend
helm package .
mv frontend-0.1.0.tgz ../

cd ../backend
helm package .
mv backend-0.1.0.tgz ../
```
![alt text](<images/Screenshot from 2024-08-29 12-53-28.png>)
---


## Deploy Multi-Tier Application Using Helm

Deploy the backend chart:

```sh
helm install backend ./backend-0.1.0.tgz
```
![alt text](<images/Screenshot from 2024-08-29 23-41-56.png>)
---


Deploy the frontend chart:

```sh
helm install frontend ./frontend-0.1.0.tgz
```
![alt text](<images/Screenshot from 2024-08-29 23-25-34.png>)
---


## Manage Helm Secrets

Use Helm secrets to manage sensitive data:

```sh
helm secrets enc secrets.yaml
```

Example `secrets.yaml`:

```yaml
database:
  password: "your-password"
aws:
  access_key: "your-access-key"
  secret_key: "your-secret-key"
```

## Implement RBAC

Create a Role and RoleBinding for Helm:

`rbac.yaml`:

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: helm-role
rules:
- apiGroups: ["", "apps", "extensions"]
  resources: ["pods", "deployments", "services", "secrets", "configmaps"]
  verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: helm-rolebinding
  namespace: default
subjects:
- kind: User
  name: helm-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: helm-role
  apiGroup: rbac.authorization.k8s.io
```

Apply the RBAC configuration:

```sh
kubectl apply -f rbac.yaml
```
![alt text](<images/Screenshot from 2024-08-29 23-51-01.png>)
---


## Validate Deployment

Check the status of Helm releases:

```sh
helm list
```
![alt text](<images/Screenshot from 2024-08-29 23-42-57.png>)
---


Verify that the frontend service is pulling files from the S3 bucket and that the backend is connecting to the RDS MySQL database.

## Cleanup


+ To clean up the resources created by this guide:
```
helm uninstall frontend
helm uninstall backend
```


+ Delete s3 Bucket
```
aws s3 rm s3://your-bucket-name/ --recursive
```
```
aws rds delete-db-instance --db-instance-identifier mydbinstance --skip-final-snapshot
```
![alt text](<images/Screenshot from 2024-08-29 23-59-06.png>)
---


```
minikube stop
minikube delete
```
![alt text](<images/Screenshot from 2024-08-30 00-01-47.png>)
---