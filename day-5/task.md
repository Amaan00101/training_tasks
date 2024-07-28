## Docker and Kubernetes Projects

### Project 01: Deploying a Scalable Web Application with Persistent Storage and Advanced Automation

### Step 1: Set up Docker Swarm and Create a Service

1. **Initialize Docker Swarm:**
    ```bash
    docker swarm init
    ```

2. **Create a Docker Swarm Service:**
    Create a simple Nginx service in Docker Swarm:
    ```bash
    docker service create --name nginx-service --publish 8080:80 nginx
    ```

![alt text](<images/Screenshot from 2024-07-15 11-04-49.png>)


### Step 2: Set up Kubernetes Using Minikube

1. **Start Minikube:**
    ```bash
    minikube start
    ```

2. **Deploy a Web App on Kubernetes:**
    - Create a deployment file named `webapp-deployment.yaml`:
      ```yaml
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: webapp
      spec:
        replicas: 2
        selector:
          matchLabels:
            app: webapp
        template:
          metadata:
            labels:
              app: webapp
          spec:
            containers:
            - name: webapp
              image: nginx
              ports:
              - containerPort: 80
      ```

    - Apply the deployment:
      ```bash
      kubectl apply -f webapp-deployment.yaml
      ```

3. **Expose the Deployment:**
    ```bash
    kubectl expose deployment webapp --type=NodePort --port=80
    ```

![alt text](<images/Screenshot from 2024-07-15 11-07-55.png>)


### Step 3: Deploy a Web Application Using Docker Compose

1. **Create a `docker-compose.yml` File:**
    ```yaml
    version: '3'
    services:
      web:
        image: nginx
        ports:
          - "8080:80"
        volumes:
          - webdata:/usr/share/nginx/html
    volumes:
      webdata:
    ```

2. **Deploy the Web Application:**
    ```bash
    docker-compose up -d
    ```

![alt text](<images/Screenshot from 2024-07-15 11-38-19.png>)


### Step 4: Automate the Entire Process Using Advanced Shell Scripting

1. **Create a Shell Script `deploy.sh`:**
    ```bash
    #!/bin/bash

    # Initialize Docker Swarm
    docker swarm init

    # Create Docker Swarm Service
    docker service create --name nginx-service --publish 8080:80 nginx

    # Start Minikube
    minikube start

    # Create Kubernetes Deployment
    kubectl apply -f webapp-deployment.yaml

    # Expose the Deployment
    kubectl expose deployment webapp --type=NodePort --port=80

    # Deploy Web App Using Docker Compose
    docker-compose -f docker-compose-single-volume.yml up -d

    echo "Deployment completed successfully!"
    ```

2. **Make the Script Executable:**
    ```bash
    chmod +x deploy.sh
    ```

3. **Run the Script:**
    ```bash
    ./deploy.sh
    ```

![alt text](<images/Screenshot from 2024-07-15 11-40-04.png>)



## Project 02: Comprehensive Deployment of a Multi-Tier Application with CI/CD Pipeline

### Step 1: Set up Docker Swarm and Create a Multi-Tier Service

1. **Initialize Docker Swarm:**
    ```bash
    docker swarm init
    ```

2. **Create a Multi-Tier Docker Swarm Service:**
    - Create a `docker-compose-swarm.yml` file:
      ```yaml
      version: '3.7 '
      services:
        frontend:
          image: nginx
          ports:
            - "8080:80"
          deploy:
            replicas: 2

        backend:
          image: my-backend-image
          deploy:
            replicas: 2

        db:
          image: postgres
          environment:
            POSTGRES_USER: user
            POSTGRES_PASSWORD: password
            POSTGRES_DB: mydatabase
          volumes:
            - db-data:/var/lib/postgresql/data
          deploy:
            replicas: 1

      volumes:
        db-data:
      ```

    - Deploy the stack:
      ```bash
      docker stack deploy -c docker-compose-swarm.yml myapp
      ```

![alt text](<images/Screenshot from 2024-07-15 11-52-12.png>)


### Step 2: Set up Kubernetes Using Minikube

1. **Start Minikube:**
    ```bash
    minikube start
    ```

2. **Create Kubernetes Deployment Files:**

- Create Kubernetes Deployment Files
```bash
Create frontend-deployment.yaml:
Create backend-deployment.yaml:
Create db-deployment.yaml:
Create shared-pvc.yaml:
Create db-pvc.yaml:
```

![alt text](<images/Screenshot from 2024-07-15 11-56-31.png>)


- Apply the deployments:
```bash
kubectl apply -f shared-pvc.yaml
kubectl apply -f db-pvc.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f db-deployment.yaml
```

![alt text](<images/Screenshot from 2024-07-16 00-12-05.png>)


### Step 3: Deploy a Multi-Tier Application Using Docker Compose

1. **Create a `docker-compose.yml` File:**
    ```yaml
    version: '3'
    services:
      frontend:
        image: nginx
        ports:
          - "8080:80"

      backend:
        image: my-backend-image

      db:
        image: postgres
        environment:
          POSTGRES_USER: user
          POSTGRES_PASSWORD: password
          POSTGRES_DB: mydatabase
        volumes:
          - db-data:/var/lib/postgresql/data

    volumes:
      db-data:
    ```

2. **Deploy the Application:**

```bash
docker-compose up -d
```

![alt text](<images/Screenshot from 2024-07-15 22-46-26.png>)