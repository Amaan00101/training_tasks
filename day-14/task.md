## Day-14 Project

### CI/CD Pipeline for Java Application

This project sets up a CI/CD pipeline using Jenkins to streamline the deployment process of a simple Java application. The pipeline performs the following tasks:

1. **Fetch the Dockerfile**: Clones a GitHub repository containing the source code and Dockerfile.
2. **Create a Docker Image**: Builds a Docker image from the Dockerfile.
3. **Push the Docker Image**: Pushes the Docker image to a specified DockerHub repository.
4. **Deploy the Container**: Deploys a container using the pushed Docker image.

### Deliverables:

**1. Create and Configure the GitHub Repository:**
+ Creat a new reposatory
+ Add Dockerfile and app.java
+ push the files on github

![alt text](<images/Screenshot from 2024-07-29 16-07-19.png>)

![alt text](<images/Screenshot from 2024-07-29 16-19-47.png>)


**2. GitHub Repository:** A GitHub repository containing:
+ The source code of a simple Java application.
+ A Dockerfile for building the Docker image.

![alt text](<images/Screenshot from 2024-07-30 15-25-04.png>)


**3. Jenkins Pipeline Script:** A Jenkinsfile (pipeline script) that:
+ Clones the GitHub repository.
+ Builds the Docker image.
+ Pushes the Docker image to DockerHub.
+ Deploys a container using the pushed image.
```shell
pipeline {
    agent any
    environment {
        registry = 'docker.io'  
        registryCredential = 'docker-hub' 
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Amaan00101/training_day-14.git', branch: 'main'
            }
        }
        stage('build image') {
            steps{
                script{
                    docker.withRegistry('', registryCredential){
                        def customImage = docker.build("amaan00101/myjava-app:${env.BUILD_ID}")
                        customImage.push()
                    }
                }
            }
        }
        stage('Deploy Container') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        def runContainer = docker.image("amaan00101/myjava-app:${env.BUILD_ID}").run('--name mynew-container -d')
                        echo "Container ID: ${runContainer.id}"
                    }
                }
            }
        }
        stage('Output') {
            steps{
                script{
                    sh 'java App.java'
                }
            }
        }
    }
}
```

**4. DockerHub Repository:** A DockerHub repository where the Docker images will be stored.

![alt text](<images/Screenshot from 2024-07-30 15-17-44.png>)


**5. Jenkins Setup:**
+ Jenkins installed and configured on a local Ubuntu machine.
+ Required plugins installed (e.g., Git, Docker, Pipeline).

![alt text](<images/Screenshot from 2024-07-29 16-45-50.png>)


**6. Documentation:** Detailed documentation explaining:

+ How to set up the local Jenkins environment.

![alt text](<images/Screenshot from 2024-07-29 16-46-53.png>)
---

+ Configuration steps for the pipeline.

![alt text](<images/Screenshot from 2024-07-29 17-17-29.png>)
---

+ Instructions for verifying the deployment.

![alt text](<images/Screenshot from 2024-07-29 17-15-45.png>)

![alt text](<images/Screenshot from 2024-07-29 17-16-45.png>)

![alt text](<images/Screenshot from 2024-07-29 17-23-31.png>)
---