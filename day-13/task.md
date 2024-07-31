## Multi-Branch Java Maven Project with Jenkins

### Project Overview

+ Create a simple Java Maven project.
+ Version-control the project using Git with multiple branches.
+ Set up Jenkins multi-branch pipeline for automated build and deployment.
+ Utilize Jenkins environment variables in the Jenkinsfile.

### Project Objectives

+ Version-control using Git.
+ Jenkins multi-branch pipeline setup.
+ Environment variable management using Jenkinsfile.


### Project Deliverables

1. **Git Repository:**
   - Local Git repository initialized.
   - Branches: `development`, `staging`, and `production`.
   - Repository pushed to a remote Git server.

2. **Maven Project:**
   - Simple Java Maven project (HelloWorld application).
   - `pom.xml` file with dependencies and build configurations.

3. **Jenkins Setup:**
   - Multi-branch pipeline job configured in Jenkins.
   - `Jenkinsfile` defining build and deployment steps.
   - Environment variables managed using Jenkins settings.

### Step-by-Step Guide

#### 1. Set Up the Maven Project

**1.1 Initialize Maven Project**

+ Create a new directory for your project:

```sh
mkdir Jenkins-training-task
cd Jenkins-training-task
```

**1.2 Initialize Git Repository**

Initialize the Git repository and commit the initial project:

```sh
git init
git add .
git commit -m "Initial commit of Maven project"
```

![alt text](<images/Screenshot from 2024-07-25 16-42-21.png>)
---


**1.3 Create and Push Branches**

Create and push the `development`, `staging`, and `production` branches:

```sh
git checkout -b development
git push -u origin development
```

![alt text](<images/Screenshot from 2024-07-25 17-04-07.png>)
---


```sh
git checkout -b staging
git push -u origin staging

git checkout main
git push -u origin main
```

![alt text](<images/Screenshot from 2024-07-25 17-05-57.png>)
---


**1.4 Define `pom.xml`**

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/POM/4.0.0/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>helloworld</artifactId>
    <version>1.0-SNAPSHOT</version>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

**1.5 Add HelloWorld Java Class**

Update `src/main/java/com/example/App.java` to:

```java
package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
```

#### 2. Set Up Jenkins

**2.1 Install Jenkins**

Follow the [Jenkins installation guide](https://www.jenkins.io/doc/book/installing/) to set up Jenkins on your server.

**2.2 Configure Jenkins**

- **Install Required Plugins:**
  - Git Plugin
  - Pipeline Plugin
  - GitHub Integration Plugin (if using GitHub)

- **Create Multi-Branch Pipeline Job:**

  1. Open Jenkins and click "New Item."
  2. Enter a name for the job and select "Multibranch Pipeline."
  3. Click "OK."
  4. Under "Branch Sources," add your Git repository URL and credentials if necessary.
  5. Configure the branch sources to include `development`, `staging`, and `production` branches.

![alt text](<images/Screenshot from 2024-07-25 16-01-03.png>)
---


**2.3 Create Jenkinsfile**

Create a `Jenkinsfile` in the root of your Git repository:

```groovy
pipeline {
    agent any

    environment {
        MAVEN_HOME = tool name: 'Maven 3.6.3', type: 'maven'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    withMaven(maven: 'Maven 3.6.3') {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "Deploying application..."
                    // Deployment steps go here
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
            junit '**/target/test-*.xml'
        }
    }
}
```

**2.4 Configure Jenkins Environment Variables**

![alt text](<images/Screenshot from 2024-07-31 15-17-21.png>)

![alt text](<images/Screenshot from 2024-07-31 15-43-26.png>)
---


**2.5 Add Environment Variables**

- Go to **Manage Jenkins** > **Configure System**.
- Under **Global properties**, check **Environment variables**.
- Add any necessary environment variables here, such as `MAVEN_HOME`.

![alt text](<images/Screenshot from 2024-07-31 15-15-38.png>)
---


**2.6 Test the Setup**

- Push changes to your Git repository.
- Jenkins should automatically detect the changes and start the pipeline for each branch.
- Monitor the build and deployment process in the Jenkins dashboard.

![alt text](<images/Screenshot from 2024-07-31 15-21-51.png>)
---