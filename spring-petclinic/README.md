# 🚀 Project 1 — Spring PetClinic End-to-End CI/CD Pipeline on AWS EC2

## 🧩 Overview
This project demonstrates a complete *DevOps CI/CD pipeline* from scratch using *Jenkins, Maven, SonarQube, and Docker* — deployed on *AWS EC2 (Ubuntu 22.04)*.  
The project automates the build, quality analysis, containerization, and deployment of the *Spring PetClinic* Java application.

---

##  Step-by-Step Implementation

### 1 — EC2 Instance Setup
- *Instance Type:* t2.micro (Free Tier)  
- *Volume:* 40 GB  
- *OS:* Ubuntu 22.04  
- *Security Groups:*  
  - Port 22 → SSH  
  - Port 8081 → Application  
  - Port 9000 → SonarQube  
  - Port 8080 → Jenkins  

-  Update system before setup:
```bash
sudo apt update && sudo apt upgrade -y
```

## Step 2 — Tools Installation
  1. Install Java 17:
     ```bash
      sudo apt install openjdk-17-jdk -y
      java --version
      ```

  2. Install Jenkins:
      ```bash
      curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list >    /dev/null
     sudo apt-get update
     sudo apt-get install jenkins -y
     ```
     Start Jenkins:
     ```bash
      sudo systemctl enable jenkins
      sudo systemctl start jenkins
      sudo systemctl status jenkins
      ```
     Access Jenkins:
      ```bash
      http://<your-ec2-public-ip>:8080
      ```
     Get initial admin password:
     sudo cat /var/lib/jenkins/secret/initialAdminPassword

  3. Install Docker
       ```bash
       sudo apt install docker.io -y
       docker --version
       sudo systemctl status docker
       ```
     Grant Jenkins access to Docker:
      ```bash
      sudo usermod -aG docker jenkins
      sudo systemctl restart jenkins
      ```
  4. Install Maven:
      ```bash
      sudo apt install maven -y
      mvn --version
      ```

  5. Run SonarQube in Docker:
     ```bash
      docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
     ```
     Access SonarQube at:
      ```bash
      http://<your-ec2-public-ip>:9000
      ```
     Default credentials:
      ```bash
      Username: admin
      Password: admin
      ```
     Generate a token from:
     My Account → Security → Generate Tokens
     Save it in Jenkins Credentials as Secret Text.

 ## Step 3 — Configure Tools in Jenkins
      
   Install Required Plugins
   Navigate to:
   Manage Jenkins → Plugins → Available plugins
   
   Install:
    Maven Integration
    Docker Pipeline
    SonarQube Scanner
    Git
  
   Restart Jenkins after installation.

   Configure Maven:

   Manage Jenkins → Global Tool Configuration → Maven → Add Maven

    Name: MAVEN_HOME
    Path: /usr/share/maven

   Configure JDK:

   Manage Jenkins → Global Tool Configuration → JDK → Add JDK

    Name: JAVA17
    Uncheck: Install automatically
	Path: /usr/lib/jvm/java-17-openjdk-amd64

   Configure SonarQube Server:

   Manage Jenkins → System → SonarQube servers → Add SonarQube

    Name: SonarQube
    Server URL: http://<your-ec2-ip>:9000
    Authentication Token: Your Sonar token

   Manage Jenkins → Global Tool Configuration → SonarQube Scanner → Add SonarQube Scanner

    Name: SonarQubeScanner
    Install automatically

   Configure Docker Hub Credentials:

   Log in to Docker Hub → Account Settings → Security → New Access Token
   Copy the token

   In Jenkins:

   Go to: Manage Jenkins → Credentials → Global → Add Credentials

    Kind: Username and password
    Username: your Docker Hub username
    Password: the access token
    ID: docker-cred
    Description: Docker Hub Credentials

 ## Step 4 — Executing the CI/CD Pipeline
   Pipeline Setup:

   Create a New Pipeline Job

   Jenkins Dashboard → New Item → Pipeline → Name: spring-petclinic-pipeline → OK

   Link to GitHub Repository (SCM Integration)

   Under Pipeline → Definition, choose Pipeline script from SCM
   SCM: Git/
   Repository URL:
   ```bash
   https://github.com/<your-username>/<repo-name>.git
   ```
   Branch Spec: /main
   Script Path: spring-petclinic/Jenkinsfile
   Save the job.

   Pipeline Stages Breakdown:

   The CI/CD pipeline defined in the Jenkinsfile is structured into multiple automated stages:

        | Stage | Purpose | Key Actions |
        |-------|----------|-------------|
        | *1. Checkout Code* | Pulls the latest source code from the GitHub repository. | Uses Jenkins Git plugin to clone the main branch from SCM. |
        | *2. Build with Maven* | Compiles and packages the Spring Boot application. | Runs mvn clean package -DskipTests to generate the .jar file. |
        | *3. SonarQube Analysis* | Ensures code quality and security compliance. | Performs static code analysis using the SonarQube server configured in Jenkins. |
        | *4. Docker Build & Push* | Builds a Docker image and pushes it to Docker Hub. | Uses docker build -t chinmai316/spring-petclinic:${BUILD_NUMBER} . and docker push. |
        | *5. Deploy to EC2* | Deploys the application container to AWS EC2. | Stops any old container, removes it, and runs the new image exposing port 8081. | 

  Running the Pipeline:
        
   • Open Jenkins dashboard → your pipeline → Build Now.
   • Each stage (checkout, build, sonar, docker, deploy) runs sequentially.

  Verification:
    
   Once the pipeline completes successfully
   Visit your deployed app in the browser:
   ```bash
   http://ec2-publicip:8081
   ```

  Confirm the PetClinic homepage loads successfully

  The Spring PetClinic homepage should load successfully.

## Optimization
   Originally, the Docker image size was ~600 MB.
   After implementing a multi-stage Docker build, it was reduced to ~135 MB — faster builds, lighter deployments, and quicker rollouts.

### Outcome
  • CI/CD pipeline fully automated through Jenkins.
  • SCM integration ensures automatic builds on code updates.
  • Quality checks via SonarQube before containerization.
  • Docker images securely pushed to Docker Hub.
  • One-click deployment on EC2 through Jenkins.

### Key Learnings & Takeaways

   What I Implemented
	 • Built a complete CI/CD pipeline from scratch using Jenkins, Maven, SonarQube, Docker, and AWS EC2.
	 • Integrated GitHub → Jenkins → Docker Hub → EC2 for end-to-end automation.
	 • Designed a pipeline that automatically triggers on code changes and performs build → test → quality scan → containerize → deploy.

   Troubleshooting & Debugging Learned
	 • Fixed ClassNotFoundException by creating a proper main class (PetClinicApplication.java).
	 • Resolved unable to access jarfile errors by adjusting the working directory and artifact paths.
	 • Verified environment variables (JAVA_HOME, PATH) and permission issues on EC2 during Jenkins setup.

   Outcome
	 • Achieved a fully automated, reliable CI/CD workflow.
	 • The pipeline can now rebuild, retest, and redeploy automatically on each commit.
	 • Application successfully runs on EC2 via Docker  

