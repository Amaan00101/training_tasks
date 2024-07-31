## Day-15 Project - 1

### CI/CD Pipeline for Java Application

This project sets up a CI/CD pipeline using Jenkins to streamline the deployment process of a simple Java application. The pipeline performs the following tasks:


### Deliverables:

**1. Create and Configure the GitHub Repository:**
+ Creat a new reposatory
+ Add Dockerfile and app.java
+ push the files on github

![alt text](<images/Screenshot from 2024-07-30 10-14-02.png>)


**2. GitHub Repository:** A GitHub repository containing:
+ The source code of a simple Java application.
+ A Dockerfile for building the Docker image.

![alt text](<images/Screenshot from 2024-07-30 19-49-14.png>)


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

![alt text](<images/Screenshot from 2024-07-30 19-46-24.png>)
---

+ Configuration steps for the pipeline.

![alt text](<images/Screenshot from 2024-07-30 19-53-59.png>)
---

+ Instructions for verifying the deployment.

![alt text](<images/Screenshot from 2024-07-30 19-53-23.png>)

![alt text](<images/Screenshot from 2024-07-30 19-53-38.png>)

![alt text](<images/Screenshot from 2024-07-30 19-53-07.png>)
---


## Project - 2

### Ansible Playbook:

#### Basic Playbook Creation:

#### Inventory File:

+ Create an inventory file specifying the target server(s) for deployment.
```yaml
[webservers]
172.2x.xx.xx ansible_user=amaan ansible_ssh_pass=xxxx ansible_become_pass=xxxx
```


+ Develop an Ansible playbook to automate the deployment of the Docker container.
```yaml
---
- name: Deploying container
  hosts: webservers
  become: yes
  tasks:
    - name: Instaling python pip
      apt:
        name: python3-pip
        state: present
        update_cache: yes

    - name: Installing Docker SDK
      pip:
        name: docker
        state: present

    - name: Installing Docker
      apt:
        name: docker.io
        state: present
        update_cache: yes

    - name: Making dokcer service running
      service:
        name: docker
        state: started
        enabled: yes

    - name: Pulling docker image
      docker_image:
        name: amaan00101/myjava-app
        tag: 9
        source: pull

    - name: Running docker container
      docker_container:
        name: my_test_container
        image: amaan00101/myjava-app:9
        state: started
        restart_policy: always
        ports:
          - "8091:80"
```


#### Playbook Tasks:

+ Install Docker on the target server (if Docker is not already installed).

+ Pull the Docker image from the container registry.

+ Run the Docker container with the required configurations.

![alt text](<images/Screenshot from 2024-07-29 19-07-20.png>)

