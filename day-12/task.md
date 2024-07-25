### Project

#### 1. Setup Jenkins Job
+ Create a new Jenkins pipeline job.

![alt text](<images/Screenshot from 2024-07-25 11-37-01.png>)
---

+ Configure the job to pull the Jenkinsfile from the GitHub repository.

![alt text](<images/Screenshot from 2024-07-25 11-33-31.png>)
---

#### 2. Create Jenkinsfile
+ Write a declarative pipeline script (Jenkinsfile) that includes the following stages:
    - Clone Repository: Clone the Maven project from the GitHub repository.
    - Build: Execute the Maven build process (mvn clean install).
    - Test: Run unit tests as part of the Maven build.
    - Archive Artifacts: Archive the build artifacts for future use.

```
pipeline {
    agent any
    tools {
        maven 'Maven-3.9.0'
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Amaan00101/training_day-11.git', branch: 'main', credentialsId: 'new_id'
            }
        }
        stage ('maven build') {
            steps {
                    sh "mvn clean install"                        
                }
            }
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
            }
        }
    }
    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Pipeline succeeded.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
```

#### 3. Configure Pipeline Parameters
+ Allow the pipeline to accept parameters such as Maven goals and options for flexibility.
+ Ensure the pipeline can be easily modified for different build configurations.



#### 4. Run the Pipeline
+ Trigger the Jenkins pipeline job manually or set up a webhook for automatic triggering on GitHub repository changes.
+ Monitor the build process through Jenkins' UI and console output.

![alt text](<images/Screenshot from 2024-07-25 11-31-50.png>)

![alt text](<images/Screenshot from 2024-07-25 11-32-35.png>)
---

#### 5. Deliverables
+ Jenkinsfile: A declarative pipeline script with the defined stages and steps.
+ Jenkins Job Configuration: Configured Jenkins job that uses the Jenkinsfile from the GitHub repository.
+ Build Artifacts: Successfully built and archived artifacts stored in Jenkins.
+ Build Reports: Output of the build process, including unit test results, displayed in Jenkins.
+ Pipeline Visualization: Visual representation of the pipeline stages and steps in Jenkins, showing the flow and status of each build stage.
+ Documentation: Detailed documentation outlining the pipeline setup process, including prerequisites, configuration steps, and instructions for modifying the pipeline.

![alt text](<images/Screenshot from 2024-07-25 13-53-50.png>)

![alt text](<images/Screenshot from 2024-07-25 15-37-45.png>)
---