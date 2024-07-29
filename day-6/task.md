## Deployment Projects

### Project 01: Deploying a Node.js App Using Minikube Kubernetes

#### Set Up Git Version Control

1. **Initialize a Git Repository**
   ```bash
   mkdir nodejs-k8s-project
   cd nodejs-k8s-project
   git init
   ```

#### Create a Node.js Application

1. **Initialize a Node.js project**
   ```bash
   npm init -y
   ```

![alt text](<images/Screenshot from 2024-07-16 10-38-03.png>)


2. **Install Express.js**
   ```bash
   npm install express
   ```

3. **Create `index.js`**
   ```javascript
   // Example content
   const express = require('express');
   const app = express();
   app.get('/', (req, res) => res.send('Hello World!'));
   app.listen(3000, () => console.log('App listening on port 3000!'));
   ```

4. **Create a `.gitignore` file**
   ```
   node_modules
   ```

#### Commit the Initial Code

1. **Add files to Git**
   ```bash
   git add .
   ```

2. **Commit the changes**
   ```bash
   git commit -m "Initial commit with Node.js app"
   ```

![alt text](<images/Screenshot from 2024-07-16 10-39-10.png>)


#### Branching and Fast-Forward Merge

1. **Create a New Branch**
   ```bash
   git checkout -b feature/add-route
   ```

2. **Implement a New Route**
   Modify `index.js` to add a new route:
   ```javascript
   app.get('/newroute', (req, res) => res.send('This is a new route!'));
   ```

3. **Commit the changes**
   ```bash
   git add .
   git commit -m "Add new route"
   ```

4. **Merge the Branch Using Fast-Forward**
   ```bash
   git checkout main
   git merge --ff-only feature/add-route
   git branch -d feature/add-route
   ```

![alt text](<images/Screenshot from 2024-07-16 11-03-41.png>)


#### Containerize the Node.js Application

1. **Create a `Dockerfile`**
   ```Dockerfile
   # Example content
   FROM node:14
   WORKDIR /app
   COPY package*.json ./
   RUN npm install
   COPY . .
   CMD ["node", "index.js"]
   ```

2. **Build and Test the Docker Image**
   ```bash
   docker build -t nodejs-k8s-app .
   docker run -p 3000:3000 nodejs-k8s-app
   ```

   Access the app at [http://localhost:3000](http://localhost:3000).

![alt text](<images/Screenshot from 2024-07-16 11-56-33.png>)   


#### Deploying to Minikube Kubernetes

1. **Start Minikube**
   ```bash
   minikube start
   ```

2. **Create Kubernetes Deployment and Service Manifests**

   - `deployment.yaml`
   - `service.yaml` (ClusterIP)
   - `service-nodeport.yaml` (NodePort)

3. **Apply Manifests to Minikube**
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f service-nodeport.yaml
   ```

4. **Access the Application**
   ```bash
   minikube ip
   curl http://<minikube-ip>:30001
   ```

![alt text](<images/Screenshot from 2024-07-16 12-00-20.png>)

![alt text](<images/Screenshot from 2024-07-16 12-01-06.png>)


#### Making Changes to the Node.js Application

1. **Create a New Branch for Changes**
   ```bash
   git checkout -b feature/update-message
   ```

2. **Update the Application**
   Modify `index.js` to change the message:
   ```javascript
   app.get('/', (req, res) => res.send('Updated message!'));
   ```

3. **Commit the Changes**
   ```bash
   git add .
   git commit -m "Update main route message"
   ```

![alt text](<images/Screenshot from 2024-07-16 22-18-57.png>)


4. **Merge the Changes and Rebuild the Docker Image**
   ```bash
   git checkout main
   git merge --ff-only feature/update-message
   git branch -d feature/update-message
   docker build -t nodejs-k8s-app:v2 .
   ```

![alt text](<images/Screenshot from 2024-07-16 22-19-56.png>)


5. **Update Kubernetes Deployment**
   Modify `deployment.yaml` to use the new image version:
   ```yaml
   image: nodejs-k8s-app:v2
   ```

   Apply the updated deployment:
   ```bash
   kubectl apply -f deployment.yaml
   ```

![alt text](<images/Screenshot from 2024-07-16 22-26-14.png>)


6. **Verify the Update**
   ```bash
   kubectl rollout status deployment/nodejs-app
   ```

   Access the updated application:
   - Through ClusterIP Service:
     ```bash
     kubectl port-forward service/nodejs-service 7000:80
     ```
     Open [http://localhost:7000](http://localhost:7000) in your browser.

![alt text](<images/Screenshot from 2024-07-16 23-46-48.png>)

![alt text](<images/Screenshot from 2024-07-16 23-46-33.png>)

   - Access Through NodePort Service:
     ```bash
     curl http://<minikube-ip>:30001
     ```

![alt text](<images/Screenshot from 2024-07-16 23-48-17.png>)


---

### Project 02: Deploying a Python Flask App Using Minikube Kubernetes

#### Set Up Git Version Control

1. **Initialize a Git Repository**
   ```bash
   mkdir flask-k8s-project
   cd flask-k8s-project
   git init
   ```

#### Create a Python Flask Application

1. **Create a Virtual Environment**
   ```bash
   python -m venv venv
   source venv/bin/activate
   ```

![alt text](<prohect-2/Screenshot from 2024-07-17 00-03-10.png>)


2. **Install Flask**
   ```bash
   pip install Flask
   ```

3. **Create `app.py`**
   ```python
   from flask import Flask
   app = Flask(__name__)

   @app.route('/')
   def hello():
       return 'Hello World!'

   if __name__ == '__main__':
       app.run(host='0.0.0.0', port=5000)
   ```

4. **Create a `requirements.txt` file**
   ```
   Flask
   ```

5. **Create a `.gitignore` file**
   ```
   venv
   ```

#### Commit the Initial Code

1. **Add files to Git**
   ```bash
   git add .
   ```

2. **Commit the changes**
   ```bash
   git commit -m "Initial commit with Flask app"
   ```

![alt text](<prohect-2/Screenshot from 2024-07-17 00-07-21.png>)


#### Branching and Fast-Forward Merge

1. **Create a New Branch**
   ```bash
   git checkout -b feature/add-route
   ```

2. **Implement a New Route**
   Modify `app.py` to add a new route:
   ```python
   @app.route('/newroute')
   def new_route():
       return 'This is a new route!'
   ```

3. **Commit the changes**
   ```bash
   git add .
   git commit -m "Add new route"
   ```

4. **Merge the Branch Using Fast-Forward**
   ```bash
   git checkout main
   git merge --ff-only feature/add-route
   git branch -d feature/add-route
   ```

![alt text](<prohect-2/Screenshot from 2024-07-17 00-22-39.png>)


#### Containerize the Flask Application

1. **Create a `Dockerfile`**
   ```Dockerfile
   # Example content
   FROM python:3.9
   WORKDIR /app
   COPY requirements.txt .
   RUN pip install -r requirements.txt
   COPY . .
   CMD ["python", "app.py"]
   ```

2. **Build and Test the Docker Image**
   ```bash
   docker build -t flask-k8s-app .
   docker run -p 5000:5000 flask-k8s-app
   ```

+ Access the app at [http://localhost:5000](http://localhost:5000).

![alt text](<prohect-2/Screenshot from 2024-07-17 00-24-17.png>)

![alt text](<prohect-2/Screenshot from 2024-07-17 00-24-52.png>)


#### Deploying to Minikube Kubernetes

1. **Start Minikube**
   ```bash
   minikube start
   ```

2. **Create Kubernetes Deployment and Service Manifests**

   - deployment.yaml
   - service.yaml (ClusterIP)
   - service-nodeport.yaml (NodePort)

![alt text](<prohect-2/Screenshot from 2024-07-17 00-29-08.png>)


3. **Apply Manifests to Minikube**
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f service-nodeport.yaml
   ```

4. **Access the Application**
   ```bash
   minikube ip
   curl http://<minikube-ip>:30001
   ```

![alt text](<prohect-2/Screenshot from 2024-07-17 00-38-10.png>)


#### Making Changes to the Flask Application

1. **Create a New Branch for Changes**
   ```bash
   git checkout -b feature/update-message
   ```

2. **Update the Application**
   Modify `app.py` to change the message:
   ```python
   @app.route('/')
   def hello():
       return 'Updated message!'
   ```

3. **Commit the Changes**
   ```bash
   git add .
   git commit -m "Update main route message"
   ```

4. **Merge the Changes and Rebuild the Docker Image**
   ```bash
   git checkout main
   git merge --ff-only feature/update-message
   git branch -d feature/update-message
   docker build -t flask-k8s-app:v2 .
   ```

![alt text](<prohect-2/Screenshot from 2024-07-17 00-42-30.png>)


5. **Update Kubernetes Deployment**
   Modify `deployment.yaml` to use the new image version:
   ```yaml
   image: flask-k8s-app:v2
   ```

   Apply the updated deployment:
   ```bash
   kubectl apply -f deployment.yaml
   ```

![alt text](<prohect-2/Screenshot from 2024-07-17 00-53-01.png>)


6. **Verify the Update**
   ```bash
   kubectl rollout status deployment/flask-app
   ```

   Access the updated application:
   - Through ClusterIP Service:
     ```bash
     kubectl port-forward service/flask-service 8080:80
     ```
     Open [http://localhost:8080] in your browser.

+ Through NodePort Service:
```bash
curl http://<minikube-ip>:30001
```
