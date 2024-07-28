## Docker Project Guide

Welcome to the Docker Project Guide! This document outlines two Docker projects that will help you learn how to manage Docker containers, create Dockerfiles, and set up a full-stack application using Docker.

## Docker Project 01

### Part 1: Creating a Container from a Pulled Image

**Objective:** Pull the official Nginx image from Docker Hub and run it as a container.

1. **Pull the Nginx Image:**
    ```bash
    docker pull nginx
    ```

2. **Run the Nginx Container:**
    ```bash
    docker run --name my-nginx -d -p 8080:80 nginx
    ```

3. **Verify the Container is Running:**
    ```bash
    docker ps
    ```

![alt text](<images/Screenshot from 2024-07-11 10-53-01.png>)


### Part 2: Modifying the Container and Creating a New Image

**Objective:** Modify the running Nginx container to serve a custom HTML page and create a new image from this modified container.

1. **Access the Running Container:**
    ```bash
    docker exec -it my-nginx /bin/bash
    ```

2. **Create a Custom HTML Page:**
    ```bash
    echo "<html><body><h1>Hello from Docker!</h1></body></html>" > /usr/share/nginx/html/index.html
    exit
    ```

3. **Commit the Changes to Create a New Image:**
    ```bash
    docker commit my-nginx custom-nginx
    ```

4. **Run a Container from the New Image:**
    ```bash
    docker run --name my-custom-nginx -d -p 8081:80 custom-nginx
    ```

5. **Verify the New Container:**
    Visit [http://localhost:8081](http://localhost:8081) in your browser. You should see your custom HTML page.

![alt text](<images/Screenshot from 2024-07-11 11-03-14.png>)

![alt text](<images/Screenshot from 2024-07-11 11-03-39.png>)


### Part 3: Creating a Dockerfile to Build and Deploy a Web Application

**Objective:** Write a Dockerfile to create an image for a simple web application and run it as a container.

1. **Create a Project Directory:**
    ```bash
    mkdir my-webapp
    cd my-webapp
    ```

2. **Create a Simple Web Application:**
    - Create an `index.html` file:
      ```html
      <!DOCTYPE html>
      <html>
      <body>
        <h1>Hello from My Web App!</h1>
      </body>
      </html>
      ```

3. **Write the Dockerfile:**
    - Create a `Dockerfile` in the `my-webapp` directory with the following content:
      ```dockerfile
      # Use the official Nginx base image
      FROM nginx:latest
      # Copy the custom HTML file to the appropriate location
      COPY index.html /usr/share/nginx/html/
      # Expose port 80
      EXPOSE 80
      ```

4. **Build the Docker Image:**
    ```bash
    docker build -t my-webapp-image .
    ```

5. **Run a Container from the Built Image:**
    ```bash
    docker run --name my-webapp-container -d -p 8082:80 my-webapp-image
    ```

6. **Verify the Web Application:**
    Visit [http://localhost:8082](http://localhost:8082) in your browser. You should see your custom web application.

![alt text](<images/Screenshot from 2024-07-11 11-07-34.png>)

![alt text](<images/Screenshot from 2024-07-11 11-09-15.png>)


### Part 4: Cleaning Up

**Objective:** Remove all created containers and images to clean up your environment.

1. **Stop and Remove the Containers:**
    ```bash
    docker stop my-nginx my-custom-nginx my-webapp-container
    docker rm my-nginx my-custom-nginx my-webapp-container
    ```

2. **Remove the Images:**
    ```bash
    docker rmi nginx custom-nginx my-webapp-image
    ```

![alt text](<images/Screenshot from 2024-07-11 11-14-37.png>)

![alt text](<images/Screenshot from 2024-07-11 11-15-04.png>)


## Docker Project 02

### Part 1: Setting Up the Project Structure

**Objective:** Create a structured project directory with necessary configuration files.

1. **Create the Project Directory:**
    ```bash
    mkdir fullstack-docker-app
    cd fullstack-docker-app
    ```

2. **Create Subdirectories for Each Service:**
    ```bash
    mkdir frontend backend database
    ```

3. **Create Shared Network and Volume:**
    - Docker allows communication between containers through a shared network:
      ```bash
      docker network create fullstack-network
      ```
    - Create a volume for the PostgreSQL database:
      ```bash
      docker volume create pgdata
      ```

![alt text](<images/Screenshot from 2024-07-11 11-19-40.png>)


### Part 2: Setting Up the Database

**Objective:** Set up a PostgreSQL database with Docker.

1. **Create a Dockerfile for PostgreSQL:**

    Create a `Dockerfile` in the `database` directory with the following content:
    ```dockerfile
    FROM postgres:latest
    ENV POSTGRES_USER=user
    ENV POSTGRES_PASSWORD=password
    ENV POSTGRES_DB=mydatabase
    ```

2. **Build the PostgreSQL Image:**
    ```bash
    cd database
    docker build -t my-postgres-db .
    cd ..
    ```

![alt text](<images/Screenshot from 2024-07-11 11-33-33.png>)


3. **Run the PostgreSQL Container:**
    ```bash
    docker run --name postgres-container --network fullstack-network -v pgdata:/var/lib/postgresql/data -d my-postgres-db
    ```

![alt text](<images/Screenshot from 2024-07-11 11-35-39.png>)


### Part 3: Setting Up the Backend (Node.js with Express)

**Objective:** Create a Node.js application with Express and set it up with Docker.

1. **Initialize the Node.js Application:**
    ```bash
    cd backend
    npm init -y
    ```

2. **Install Express and pg (PostgreSQL client for Node.js):**
    ```bash
    npm install express pg
    ```

3. **Create the Application Code:**
    - In the `backend` directory, create a file named `index.js` with the following content:
      ```javascript
      const express = require('express');
      const { Client } = require('pg');
      const app = express();
      const port = 3000;

      const client = new Client({
        host: 'postgres-container',
        user: 'user',
        password: 'password',
        database: 'mydatabase'
      });

      client.connect();

      app.get('/', (req, res) => {
        res.send('Hello from Node.js with Express!');
      });

      app.get('/data', async (req, res) => {
        try {
          const result = await client.query('SELECT NOW()');
          res.send(`Current time: ${result.rows[0].now}`);
        } catch (err) {
          res.status(500).send('Error fetching data');
        }
      });

      app.listen(port, () => {
        console.log(`Server running at http://localhost:${port}/`);
      });
      ```

4. **Create a Dockerfile for the Backend:**
    - In the `backend` directory, create a file named `Dockerfile` with the following content:
      ```dockerfile
      FROM node:latest
      WORKDIR /usr/src/app
      COPY package*.json ./
      RUN npm install
      COPY . .
      EXPOSE 3000
      CMD ["node", "index.js"]
      ```

5. **Build the Backend Image:**
    ```bash
    docker build -t my-node-app .
    cd ..
    ```

6. **Run the Backend Container:**
    ```bash
    docker run --name backend-container --network fullstack-network -d my-node-app
    ```

![alt text](<images/Screenshot from 2024-07-11 11-44-04.png>)


### Part 4: Setting Up the Frontend (Nginx)

**Objective:** Create a simple static front-end and set it up with Docker.

1. **Create a Simple HTML Page:**
    - In the `frontend` directory, create a file named `index.html` with the following content:
      ```html
      <!DOCTYPE html>
      <html>
      <body>
        <h1>Hello from Nginx and Docker!</h1>
        <p>This is a simple static front-end served by Nginx.</p>
      </body>
      </html>
      ```

2. **Create a Dockerfile for the Frontend:**
    - In the `frontend` directory, create a file named `Dockerfile` with the following content:
      ```dockerfile
      FROM nginx:latest
      COPY index.html /usr/share/nginx/html/index.html
      ```

3. **Build the Frontend Image:**
    ```bash
    cd frontend
    docker build -t my-nginx-app .
    cd ..
    ```

4. **Run the Frontend Container:**
    ```bash
    docker run --name frontend-container --network fullstack-network -p 8080:80 -d my-nginx-app
    ```

![alt text](<images/Screenshot from 2024-07-11 11-59-57.png>)


### Part 5: Connecting the Backend and Database

**Objective:** Ensure the backend can communicate with the database and handle data requests.

1. **Update Backend Code to Fetch Data from PostgreSQL:**
    Ensure the `index.js` code in the backend handles the `/data` endpoint as described above.

2. **Verify Backend Communication:**
    - Access the backend container:
      ```bash
      docker exec -it backend-container /bin/bash
      ```

    - Test the connection to the database using `psql`:
      ```bash
      apt-get update && apt-get install -y postgresql-client
      psql -h postgres-container -U user -d mydatabase -c "SELECT NOW();"
      ```

    - Exit the container:
      ```bash
      exit
      ```

3. **Test the Backend API:**
    - Visit [http://localhost:3000](http://localhost:3000) to see the basic message.
    - Visit [http://localhost:3000/data](http://localhost:3000/data) to see the current date and time fetched from PostgreSQL.

![alt text](<images/Screenshot from 2024-07-11 13-53-36.png>)


### Part 6: Final Integration and Testing

**Objective:** Ensure all components are working together and verify the full-stack application.

1. **Access the Frontend:**
    Visit [http://localhost:8080](http://localhost:8080) in your browser. You should see the Nginx welcome page with the custom HTML.

2. **Verify Full Integration:**
    - Update the `index.html` to include a link to the backend:
      ```html
      <!DOCTYPE html>
      <html>
      <body>
        <h1>Hello from Nginx and Docker!</h1>
        <p>This is a simple static front-end served by Nginx.</p>
        <a href="http://localhost:3000/data">Fetch Data from Backend</a>
      </body>
      </html>
      ```

    - Rebuild and Run the Updated Frontend Container:
      ```bash
      cd frontend
      docker build -t my-nginx-app .
      docker stop frontend-container
      docker rm frontend-container
      docker run --name frontend-container --network fullstack-network -p 8080:80 -d my-nginx-app
      cd ..
      ```

3. **Final Verification:**
    Visit [http://localhost:8080](http://localhost:8080) and click the link to fetch data from the backend.

![alt text](<images/Screenshot from 2024-07-11 13-57-47.png>)

![alt text](<images/Screenshot from 2024-07-11 14-02-27.png>)