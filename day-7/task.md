## Node.js Kubernetes Projects

This repository contains two projects demonstrating how to develop and deploy Node.js applications using Kubernetes. The projects cover basic to advanced Kubernetes features, including ConfigMaps, Secrets, autoscaling, and multi-environment configuration.

### Project : Basic Node.js Application with Kubernetes

+ In this project, you will:

    - Develop a simple Node.js application.
    - Deploy it on a local Kubernetes cluster using Minikube.
    - Configure various Kubernetes features including ConfigMaps, Secrets, environment variables, and autoscaling.
    - Use Git version control practices.

### Project Steps

#### 1. Setup Minikube and Git Repository

**Start Minikube:**

```sh
minikube start
```

**Set Up Git Repository:**

+ Create a new directory and initialize a Git repository:

```sh
mkdir nodejs-k8s-project
cd nodejs-k8s-project
git init
```

+ Create a `.gitignore` file:

```
node_modules/
.env
```

+ Add and commit initial changes:

```sh
git add .
git commit -m "Initial commit"
```

![alt text](<images/Screenshot from 2024-07-17 11-31-25.png>)
---


#### 2. Develop a Node.js Application

**Create the Node.js App:**

+ Initialize the Node.js project and install packages:

```sh
npm init -y
```

![alt text](<images/Screenshot from 2024-07-17 11-35-36.png>)
---

```sh
npm install express body-parser
```

![alt text](<images/Screenshot from 2024-07-17 11-36-07.png>)
---


+ Create app.js:

```js
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
```

+ Update `package.json` to include a start script:

```json
"scripts": {
  "start": "node app.js"
}
```

**Commit the Node.js Application:**

```sh
git add .
git commit -m "Add Node.js application code"
```

![alt text](<images/Screenshot from 2024-07-17 11-39-37.png>)
---


#### 3. Create Dockerfile and Docker Compose

**Create a Dockerfile:**

```Dockerfile
FROM node:18

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]
```

+ Create a `.dockerignore` file:

```
node_modules
.npm
```

**Create `docker-compose.yml` (optional for local testing):**

```yaml
version: '3'
services:
  app:
    build: .
    ports:
      - "3000:3000"
```

**Commit Docker Configuration:**

```sh
git add Dockerfile docker-compose.yml
git commit -m "Add Dockerfile and Docker Compose configuration"
```

![alt text](<images/Screenshot from 2024-07-17 11-51-05.png>)
---


#### 4. Build and Push Docker Image

**Build Docker Image:**

```sh
docker build -t nodejs-app:latest .
```

![alt text](<images/Screenshot from 2024-07-17 12-12-21.png>)
---


**Push Docker Image to Docker Hub:**

```sh
docker tag nodejs-app:latest your-dockerhub-username/nodejs-app:latest
docker push your-dockerhub-username/nodejs-app:latest
```

**Commit Docker Image Changes:**

```sh
git add .
git commit -m "Build and push Docker image"
```

![alt text](<images/Screenshot from 2024-07-17 12-17-17.png>)
---


#### 5. Create Kubernetes Configurations

**Create Kubernetes Deployment:**

+ Create `kubernetes/deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodejs-app
  template:
    metadata:
      labels:
        app: nodejs-app
    spec:
      containers:
      - name: nodejs-app
        image: your-dockerhub-username/nodejs-app:latest
        ports:
        - containerPort: 3000
        env:
        - name: PORT
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: PORT
        - name: NODE_ENV
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: NODE_ENV
```

**Create ConfigMap and Secret:**

+ Create `kubernetes/configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  PORT: "3000"
```

+ Create `kubernetes/secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  NODE_ENV: cHJvZHVjdGlvbmFs
```

**Commit Kubernetes Configurations:**

```sh
git add kubernetes/
git commit -m "Add Kubernetes deployment, configmap, and secret"
```

![alt text](<images/Screenshot from 2024-07-17 12-23-34.png>)
---


**Apply Kubernetes Configurations:**

```sh
kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/secret.yaml
kubectl apply -f kubernetes/deployment.yaml
```

![alt text](<images/Screenshot from 2024-07-17 12-46-31.png>)
---


#### 6. Implement Autoscaling

**Create Horizontal Pod Autoscaler:**

+ Create `kubernetes/hpa.yaml`:

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: nodejs-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-app-deployment
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

+ Apply the HPA:

```sh
kubectl apply -f kubernetes/hpa.yaml
```

**Create Vertical Pod Autoscaler:**

+ Create `kubernetes/vpa.yaml`:

```yaml
apiVersion: autoscaling.k8s.io/v1beta2
kind: VerticalPodAutoscaler
metadata:
  name: nodejs-app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-app-deployment
  updatePolicy:
    updateMode: "Auto"
```

+ Apply the VPA:

```sh
kubectl apply -f kubernetes/vpa.yaml
```

![alt text](<images/Screenshot from 2024-07-17 12-46-31.png>)
---


#### 7. Test the Deployment

**Check the Status of Pods, Services, and HPA:**

```sh
kubectl get pods
kubectl get svc
kubectl get hpa
```

![alt text](<images/Screenshot from 2024-07-17 12-47-33.png>)
---


**Access the Application:**

+ Expose the Service:

```sh
kubectl expose deployment nodejs-app-deployment --type=NodePort --name=nodejs-app-service
```

+ Get the Minikube IP and Service Port:

```sh
minikube service nodejs-app-service --url
```

![alt text](<images/Screenshot from 2024-07-17 12-48-41.png>)
---


+ Access the Application in your browser using the URL obtained.

![alt text](<images/Screenshot from 2024-07-17 12-48-53.png>)
---


#### 8. Git Version Control

**Create a New Branch for New Features:**

```sh
git checkout -b feature/new-feature
```

+ Make changes and commit:

```sh
# Make some changes
git add .
git commit -m "Add new feature"
```

+ Push the branch to the remote repository:

```sh
git push origin feature/new-feature
```

![alt text](<images/Screenshot from 2024-07-17 12-51-19.png>)
---


**Rebase Feature Branch on Main Branch:**

```sh
git checkout main
git pull origin main

git checkout feature/new-feature
git rebase main
```

+ Resolve conflicts if any, and continue the rebase:

```sh
git add .
git rebase --continue
```

+ Push the rebased feature branch:

```sh
git push origin feature/new-feature --force
```

![alt text](<images/Screenshot from 2024-07-31 14-46-44.png>)
---


#### 9. Final Commit and Cleanup

**Merge Feature Branch to Main:**

```sh
git checkout main
git merge feature/new-feature
```

+ Push the changes to the main branch:

```sh
git push origin main
```

+ Clean up:

```sh
git branch -d feature/new-feature
git push origin --delete feature/new-feature
```

![alt text](<images/Screenshot from 2024-07-31 14-49-00.png>)
---