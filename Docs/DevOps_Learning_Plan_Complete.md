# 🚀 DevOps Learning Plan — Java Developer to DevOps Engineer
## Complete 3-Month Roadmap (June 22, 2026 – September 21, 2026)

**Background:** 1.8 yrs TCS | Java Developer | Spring Boot | Basic AWS
**Goal:** Complete DevOps basics, build portfolio, crack interviews, switch by Sept 2026

---

## 📋 HOW TO USE THIS DOCUMENT

1. Follow week by week — don't skip ahead
2. Check off tasks as you complete them
3. Every topic: Watch → Practice → Build → Document
4. Push everything to GitHub (this IS your resume)
5. Never watch more than 1 hour without opening terminal

---

## 📺 TOP YOUTUBE CHANNELS (Bookmark All)

| # | Channel | Best For | Language |
|---|---------|----------|----------|
| 1 | **Abhishek Veeramalla** | Zero to Hero series, Indian context, real projects | Hindi + English |
| 2 | **TechWorld with Nana** | Best animated explanations, structured | English |
| 3 | **KodeKloud** | Free hands-on labs, certification prep | English |
| 4 | **DevOps Directive** | Deep-dive project tutorials | English |
| 5 | **Bret Fisher** | Docker & K8s specialist | English |

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 📅 WEEK-BY-WEEK TRACKER
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

---

## WEEK 1 (June 22 – June 28): Linux Basics

### 🎥 Videos to Watch
- [ ] Abhishek Veeramalla — "Linux for DevOps Engineers" (search his channel)
- [ ] KodeKloud — Free "Crash Course: Linux for Absolute Beginners"
      → https://kodekloud.com/courses/crash-course-linux-for-absolute-beginners
- [ ] TechWorld with Nana — "Linux Tutorial for Beginners" on her channel

### 📝 Topics to Cover
- [ ] File system navigation (cd, ls, pwd, find, locate)
- [ ] File operations (cp, mv, rm, mkdir, touch, cat, head, tail)
- [ ] File permissions (chmod, chown, umask)
- [ ] Text processing (grep, sed, awk, cut, sort, uniq)
- [ ] Package management (apt, yum)
- [ ] Process management (ps, top, kill, systemctl)
- [ ] User management (useradd, passwd, groups)

### 🔨 Hands-On Tasks
- [ ] Launch a free-tier AWS EC2 (Ubuntu) instance
- [ ] SSH into it from your Windows machine (use PuTTY or Git Bash)
- [ ] Navigate around, create users, set permissions
- [ ] Install Java 17 and run a JAR file manually on EC2

### ✅ Week 1 Deliverable
- [ ] Can comfortably SSH and work on a remote Linux server

---

## WEEK 2 (June 29 – July 5): Shell Scripting & Networking

### 🎥 Videos to Watch
- [ ] Abhishek Veeramalla — "Shell Scripting Zero to Hero" (full playlist)
- [ ] TechWorld with Nana — "Computer Networking Course" on her channel
- [ ] KodeKloud — Networking basics section in Linux course

### 📝 Topics to Cover
- [ ] Bash scripting basics (variables, loops, conditions, functions)
- [ ] Command-line arguments, exit codes
- [ ] Cron jobs (scheduling)
- [ ] Networking: IP addresses, DNS, ports, TCP/UDP
- [ ] SSH keys (how they work, generate them)
- [ ] Firewalls (iptables basics, security groups)
- [ ] curl, wget for API testing

### 🔨 Hands-On Tasks
- [ ] Write script 1: Health check script (checks if a URL is up)
- [ ] Write script 2: Log cleanup script (delete logs older than 7 days)
- [ ] Write script 3: Backup script (tar + compress a directory)
- [ ] Write script 4: Automated Java build script (mvn + deploy JAR)
- [ ] Write script 5: System monitoring script (CPU, memory, disk)
- [ ] Set up a cron job to run your health check every 5 minutes

### ✅ Week 2 Deliverable
- [ ] 5 bash scripts pushed to GitHub
- [ ] Can explain DNS resolution, TCP handshake in simple words

---

## WEEK 3 (July 6 – July 12): Docker Fundamentals

### 🎥 Videos to Watch
- [ ] TechWorld with Nana — "Docker Tutorial for Beginners [FULL COURSE in 3 Hours]"
      → Search: "TechWorld with Nana Docker full course 3 hours"
- [ ] Abhishek Veeramalla — "Docker Zero to Hero" in his DevOps playlist
- [ ] (Optional) Bret Fisher — "Docker for Beginners" on his channel

### 📝 Topics to Cover
- [ ] What is containerization? Docker vs VMs
- [ ] Docker architecture (daemon, client, registry)
- [ ] Images vs Containers
- [ ] Dockerfile instructions (FROM, COPY, RUN, CMD, ENTRYPOINT, EXPOSE)
- [ ] Docker networking (bridge, host, none)
- [ ] Docker volumes (persisting data)
- [ ] Docker Hub (pull, push, tag)
- [ ] Multi-stage builds (important for Java!)

### 🔨 Hands-On Tasks
- [ ] Install Docker Desktop on Windows
- [ ] Pull and run nginx, mysql, postgres containers
- [ ] Write a Dockerfile for YOUR Spring Boot app
- [ ] Build the image, run it, test it
- [ ] Create a Docker Hub account and push your image
- [ ] Try multi-stage build to reduce image size

### 📄 Dockerfile for Your Spring Boot App
```dockerfile
# Multi-stage build
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### ✅ Week 3 Deliverable
- [ ] Spring Boot app running in a Docker container
- [ ] Image pushed to Docker Hub

---

## WEEK 4 (July 13 – July 19): Docker Compose & Docker in Production

### 🎥 Videos to Watch
- [ ] TechWorld with Nana — "Ultimate Docker Compose Tutorial" (1 hour)
      → Search: "TechWorld with Nana Docker Compose Tutorial"
- [ ] Abhishek Veeramalla — Docker Compose section in his Docker video
- [ ] TechWorld with Nana — "Docker Best Practices" on her channel

### 📝 Topics to Cover
- [ ] docker-compose.yml syntax (services, networks, volumes)
- [ ] Environment variables in Docker
- [ ] Docker networking between containers
- [ ] Docker logging and troubleshooting
- [ ] Docker security basics (non-root user, minimal images)
- [ ] .dockerignore file
- [ ] Container orchestration concepts (why we need K8s)

### 🔨 Hands-On Tasks
- [ ] Create docker-compose.yml: Spring Boot + MySQL
- [ ] Add environment variables for DB connection
- [ ] Add healthchecks
- [ ] Create docker-compose.yml: Spring Boot + PostgreSQL + Redis
- [ ] Practice docker logs, docker exec, docker inspect
- [ ] Optimize your image (reduce from ~500MB to ~150MB)

### 📄 Docker Compose Example
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/myapp
      - SPRING_DATASOURCE_USERNAME=root
      - SPRING_DATASOURCE_PASSWORD=secret
    depends_on:
      db:
        condition: service_healthy

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=secret
      - MYSQL_DATABASE=myapp
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  mysql_data:
```

### ✅ Week 4 Deliverable
- [ ] Multi-container app running with docker-compose
- [ ] README explaining the architecture
- [ ] Push to GitHub

---

## WEEK 5 (July 20 – July 26): CI/CD with GitHub Actions

### 🎥 Videos to Watch
- [ ] TechWorld with Nana — "GitHub Actions Tutorial" (complete)
      → Search: "TechWorld with Nana GitHub Actions"
- [ ] Abhishek Veeramalla — "GitHub Actions Complete Tutorial"
- [ ] GitHub Official — "A Beginner's Guide to CI/CD"
      → https://github.blog/developer-skills/github/a-beginners-guide-to-ci-cd-and-automation-on-github/

### 📝 Topics to Cover
- [ ] What is CI/CD? Why do we need it?
- [ ] GitHub Actions concepts (workflows, jobs, steps, runners)
- [ ] Triggers (push, pull_request, schedule, manual)
- [ ] Actions marketplace (pre-built actions)
- [ ] Secrets management in GitHub
- [ ] Artifacts and caching
- [ ] Matrix builds

### 🔨 Hands-On Tasks
- [ ] Create your first workflow: build Java project on every push
- [ ] Add test step (mvn test)
- [ ] Add Docker build step
- [ ] Add Docker push to Docker Hub (using secrets)
- [ ] Add status badge to your README
- [ ] Create a release workflow (on tag push)

### 📄 Complete CI Pipeline
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
          cache: maven

      - name: Build with Maven
        run: mvn clean package

      - name: Run Tests
        run: mvn test

  docker-build-push:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: yourusername/myapp:latest
```

### ✅ Week 5 Deliverable
- [ ] Working CI/CD pipeline on your repo
- [ ] Auto-builds and pushes Docker image on every commit

---

## WEEK 6 (July 27 – Aug 2): Advanced CI/CD + Jenkins Basics

### 🎥 Videos to Watch
- [ ] Abhishek Veeramalla — "Jenkins Zero to Hero" playlist
- [ ] TechWorld with Nana — "Jenkins Tutorial for Beginners"
- [ ] DevOps Directive — "CI/CD Pipeline with GitHub Actions + AWS" project

### 📝 Topics to Cover
- [ ] Jenkins installation (run in Docker!)
- [ ] Jenkinsfile (declarative pipeline)
- [ ] Pipeline stages: Build → Test → Docker → Deploy
- [ ] Jenkins plugins (Docker, Git, Maven)
- [ ] Webhooks (trigger Jenkins on git push)
- [ ] Jenkins vs GitHub Actions — when to use what
- [ ] GitOps concepts (intro)

### 🔨 Hands-On Tasks
- [ ] Run Jenkins in Docker: `docker run -p 8080:8080 jenkins/jenkins:lts`
- [ ] Create a freestyle job (build your Java app)
- [ ] Convert to pipeline job with Jenkinsfile
- [ ] Add Docker build stage to Jenkins pipeline
- [ ] Connect Jenkins to GitHub via webhook
- [ ] Compare: same pipeline in Jenkins vs GitHub Actions

### 📄 Sample Jenkinsfile
```groovy
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/yourusername/your-repo.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }
    }
}
```

### ✅ Week 6 Deliverable
- [ ] Jenkins running in Docker with a working pipeline
- [ ] Understand difference between Jenkins and GitHub Actions
- [ ] Can explain CI/CD to an interviewer end-to-end

---

## WEEK 7 (Aug 3 – Aug 9): AWS Core Services (Part 1)

### 🎥 Videos to Watch
- [ ] Abhishek Veeramalla — "AWS Zero to Hero" playlist (Day 1 to Day 15)
      → GitHub notes: https://github.com/iam-veeramalla/aws-devops-zero-to-hero
- [ ] TechWorld with Nana — "AWS Tutorial for Beginners"

### 📝 Topics to Cover
- [ ] AWS Account setup + Free Tier limits
- [ ] IAM (Users, Groups, Roles, Policies — VERY important)
- [ ] EC2 (Instance types, AMIs, Security Groups, Key Pairs)
- [ ] VPC (Subnets, Route Tables, Internet Gateway, NAT Gateway)
- [ ] S3 (Buckets, versioning, lifecycle policies)
- [ ] Security Groups vs NACLs
- [ ] AWS CLI setup and basic commands

### 🔨 Hands-On Tasks
- [ ] Create IAM user with limited permissions (never use root!)
- [ ] Launch EC2 instance, SSH into it, deploy Spring Boot JAR
- [ ] Create a custom VPC with public + private subnets
- [ ] Create S3 bucket, upload artifacts, set lifecycle policy
- [ ] Install AWS CLI on your machine, configure credentials
- [ ] Use AWS CLI to launch/stop EC2, list S3 buckets

### ✅ Week 7 Deliverable
- [ ] Custom VPC with proper network setup
- [ ] Spring Boot app running on EC2 (manual deploy)
- [ ] Comfortable with AWS Console + CLI

---

## WEEK 8 (Aug 10 – Aug 16): AWS DevOps Services (Part 2)

### 🎥 Videos to Watch
- [ ] Abhishek Veeramalla — "AWS Zero to Hero" playlist (Day 16 to Day 30)
- [ ] TechWorld with Nana — "AWS ECS Tutorial" on her channel
- [ ] Search YouTube: "Deploy Spring Boot to ECS Fargate tutorial"

### 📝 Topics to Cover
- [ ] ECR (Elastic Container Registry) — push Docker images
- [ ] ECS (Elastic Container Service) — run containers
- [ ] Fargate vs EC2 launch type
- [ ] ALB (Application Load Balancer) — distribute traffic
- [ ] RDS (Managed database — MySQL/PostgreSQL)
- [ ] CloudWatch (Logs, Metrics, Alarms)
- [ ] Auto Scaling basics
- [ ] Route 53 basics (DNS)

### 🔨 Hands-On Tasks
- [ ] Push your Docker image to ECR
- [ ] Create ECS cluster with Fargate
- [ ] Deploy your Spring Boot container on ECS
- [ ] Create RDS instance, connect your app to it
- [ ] Set up ALB in front of ECS
- [ ] Create CloudWatch alarm (CPU > 80%)
- [ ] Set up CloudWatch log group for your app

### 📄 Architecture You'll Build
```
Internet → ALB → ECS (Fargate) → RDS (MySQL)
                    ↓
              CloudWatch (Logs + Metrics)
```

### ✅ Week 8 Deliverable
- [ ] Full app running on AWS: ALB → ECS → RDS
- [ ] Monitoring with CloudWatch
- [ ] Update your GitHub Actions to deploy to ECS

---

## WEEK 9 (Aug 17 – Aug 23): Kubernetes Fundamentals

### 🎥 Videos to Watch
- [ ] TechWorld with Nana — "Kubernetes Tutorial for Beginners [FULL COURSE]" (~4 hrs)
      → Search: "TechWorld with Nana Kubernetes full course"
- [ ] KodeKloud — Free "Kubernetes Crash Course" with labs
      → https://kodekloud.com/courses/youtube-labs-kubernetes-crash-course
- [ ] Abhishek Veeramalla — "Kubernetes Zero to Hero" (first 5 videos)

### 📝 Topics to Cover
- [ ] Why Kubernetes? Problems it solves
- [ ] K8s Architecture (Control Plane, Worker Nodes)
- [ ] Pods — smallest deployable unit
- [ ] ReplicaSets — ensure N copies running
- [ ] Deployments — manage rollouts
- [ ] Services (ClusterIP, NodePort, LoadBalancer)
- [ ] kubectl commands (get, describe, apply, delete, logs, exec)
- [ ] Namespaces

### 🔨 Hands-On Tasks
- [ ] Install Minikube on your machine
      → `winget install minikube` or download from minikube.sigs.k8s.io
- [ ] Install kubectl
- [ ] Deploy nginx pod, expose as service
- [ ] Create a Deployment with 3 replicas
- [ ] Scale up/down, do a rolling update
- [ ] Practice kubectl: logs, exec into pod, describe

### 📄 Your First K8s Commands
```bash
# Start minikube
minikube start

# Deploy nginx
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort

# Check status
kubectl get pods
kubectl get services
kubectl describe pod <pod-name>
kubectl logs <pod-name>

# Scale
kubectl scale deployment nginx --replicas=5
```

### ✅ Week 9 Deliverable
- [ ] Minikube running locally
- [ ] Can deploy, scale, and troubleshoot pods
- [ ] Understand K8s architecture diagram

---

## WEEK 10 (Aug 24 – Aug 30): Kubernetes Advanced + Deploy Your App

### 🎥 Videos to Watch
- [ ] Abhishek Veeramalla — "Kubernetes Zero to Hero" (remaining videos)
- [ ] TechWorld with Nana — "Kubernetes ConfigMap & Secret" tutorial
- [ ] TechWorld with Nana — "Kubernetes Ingress" tutorial
- [ ] KodeKloud — Hands-on labs (continue)

### 📝 Topics to Cover
- [ ] ConfigMaps (external configuration)
- [ ] Secrets (sensitive data — DB passwords, API keys)
- [ ] Ingress (route external traffic to services)
- [ ] Persistent Volumes & Claims (storage)
- [ ] HPA — Horizontal Pod Autoscaler
- [ ] Resource limits (CPU, memory)
- [ ] Liveness & Readiness probes
- [ ] Helm basics (package manager for K8s)

### 🔨 Hands-On Tasks
- [ ] Write K8s manifests for your Spring Boot app
- [ ] Use ConfigMap for application.properties
- [ ] Use Secret for DB password
- [ ] Set up Ingress with a hostname
- [ ] Add HPA (scale when CPU > 70%)
- [ ] Add health check probes
- [ ] Deploy MySQL with PersistentVolume

### 📄 Complete K8s Manifests for Your App

**deployment.yml:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-boot-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: spring-boot-app
  template:
    metadata:
      labels:
        app: spring-boot-app
    spec:
      containers:
        - name: app
          image: yourusername/spring-boot-app:latest
          ports:
            - containerPort: 8080
          env:
            - name: SPRING_DATASOURCE_URL
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: db-url
            - name: SPRING_DATASOURCE_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: db-password
          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            initialDelaySeconds: 30
          readinessProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            initialDelaySeconds: 10
```

**service.yml:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: spring-boot-service
spec:
  selector:
    app: spring-boot-app
  ports:
    - port: 80
      targetPort: 8080
  type: ClusterIP
```

### ✅ Week 10 Deliverable
- [ ] Spring Boot app running on Minikube with full manifests
- [ ] ConfigMap, Secret, Ingress, HPA all working
- [ ] All K8s YAMLs pushed to GitHub under `/k8s` folder

---

## WEEK 11 (Aug 31 – Sept 6): Terraform (Infrastructure as Code)

### 🎥 Videos to Watch
- [ ] TechWorld with Nana — "Terraform Tutorial for Beginners" (complete course)
      → Search: "TechWorld with Nana Terraform complete"
- [ ] Abhishek Veeramalla — "Terraform Zero to Hero" playlist
- [ ] FreeCodeCamp — "HashiCorp Terraform Associate Certification Course"
      → Search YouTube: "freeCodeCamp Terraform Associate" (long video, 7+ hrs)
- [ ] HashiCorp Learn (reading): https://developer.hashicorp.com/terraform/tutorials

### 📝 Topics to Cover
- [ ] What is IaC? Why Terraform?
- [ ] Terraform vs CloudFormation vs Ansible
- [ ] HCL syntax (providers, resources, variables, outputs)
- [ ] Terraform workflow: init → plan → apply → destroy
- [ ] State file (what it is, remote backend in S3)
- [ ] Modules (reusable code)
- [ ] Data sources
- [ ] Terraform workspaces

### 🔨 Hands-On Tasks
- [ ] Install Terraform on your machine
- [ ] Write Terraform to create an EC2 instance
- [ ] Write Terraform for: VPC + Subnets + Security Groups
- [ ] Write Terraform for: S3 bucket with versioning
- [ ] Write Terraform for: RDS MySQL instance
- [ ] Set up remote state in S3 + DynamoDB lock
- [ ] Create a module for reusable VPC creation

### 📄 Sample Terraform — Create EC2
```hcl
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu
  instance_type = "t2.micro"
  key_name      = "my-key"

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "spring-boot-server"
  }
}

resource "aws_security_group" "app_sg" {
  name = "app-security-group"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "server_ip" {
  value = aws_instance.app_server.public_ip
}
```

### ✅ Week 11 Deliverable
- [ ] Can create and destroy AWS infra with Terraform
- [ ] Remote state configured
- [ ] Terraform code pushed to GitHub under `/terraform` folder

---

## WEEK 12 (Sept 7 – Sept 13): Complete Project + Terraform Advanced

### 🎥 Videos to Watch
- [ ] Abhishek Veeramalla — "End to End DevOps Project" video
- [ ] DevOps Directive — "Complete CI/CD Project" on his channel
- [ ] Search: "Spring Boot Terraform ECS complete project"

### 📝 Topics to Cover
- [ ] Terraform modules (VPC module, ECS module, RDS module)
- [ ] Terraform + GitHub Actions (auto-apply on merge)
- [ ] Complete project integration
- [ ] Git branching strategy (feature branches, PR, merge to main)
- [ ] Blue-green deployment concept
- [ ] Canary deployment concept

### 🔨 Hands-On Tasks — BUILD THE FINAL PROJECT
- [ ] Write Terraform for ENTIRE infrastructure:
      - VPC + 2 public subnets + 2 private subnets
      - Internet Gateway + NAT Gateway
      - Security Groups
      - ECR Repository
      - ECS Cluster + Service + Task Definition
      - RDS in private subnet
      - ALB in public subnet
      - CloudWatch log groups
- [ ] Connect GitHub Actions to auto-deploy:
      - On push to main → build → push to ECR → update ECS
- [ ] Write a comprehensive README with architecture diagram

### 📄 Final Project Repo Structure
```
devops-portfolio/
├── app/
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
├── .github/
│   └── workflows/
│       ├── ci.yml          # Build + Test
│       └── deploy.yml      # Deploy to ECS
├── k8s/
│   ├── deployment.yml
│   ├── service.yml
│   ├── configmap.yml
│   ├── secret.yml
│   ├── ingress.yml
│   └── hpa.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── vpc.tf
│   ├── ecs.tf
│   ├── rds.tf
│   ├── alb.tf
│   └── provider.tf
├── scripts/
│   ├── deploy.sh
│   ├── health-check.sh
│   └── backup.sh
├── docker-compose.yml
└── README.md               # ⭐ THIS IS KEY — explain everything
```

### ✅ Week 12 Deliverable
- [ ] COMPLETE end-to-end project on GitHub
- [ ] Anyone can clone and deploy with Terraform
- [ ] CI/CD auto-deploys on push
- [ ] Beautiful README with architecture diagram

---

## WEEK 13 (Sept 14 – Sept 21): Interview Preparation

### 🎥 Videos to Watch
- [ ] Abhishek Veeramalla — "DevOps Interview Questions" (all videos)
- [ ] KodeKloud — "DevOps Interview Preparation" videos
- [ ] Search: "DevOps interview questions for experienced 2025"

### 📝 Interview Questions by Topic

#### Linux
- What is the boot process in Linux?
- How do you check disk space, memory usage?
- Explain file permissions (rwx, chmod 755 meaning)
- What is the difference between soft link and hard link?
- How do you troubleshoot a process consuming high CPU?

#### Docker
- Docker vs VM — explain with diagram
- What is a multi-stage build and why use it?
- How do you reduce Docker image size?
- What is the difference between CMD and ENTRYPOINT?
- How does Docker networking work?
- How do you debug a container that keeps crashing?

#### CI/CD
- Explain your CI/CD pipeline end-to-end (USE YOUR PROJECT)
- What is the difference between CI and CD?
- How do you handle secrets in pipelines?
- What is a build artifact?
- Jenkins vs GitHub Actions — pros/cons?
- What is a webhook?

#### AWS
- What is a VPC? Explain components.
- Public vs Private subnet — when to use what?
- How does a Load Balancer work?
- ECS vs EKS — which would you choose and why?
- How do you secure an S3 bucket?
- What is IAM Role vs IAM User?
- How do you troubleshoot EC2 connectivity issues?

#### Kubernetes
- What happens when you run `kubectl apply -f deployment.yml`?
- How is a Pod different from a Container?
- How does a Service discover Pods?
- What is the difference between ClusterIP, NodePort, LoadBalancer?
- How do you troubleshoot CrashLoopBackOff?
- What is a ConfigMap vs Secret?
- Explain Liveness vs Readiness probe.
- What is HPA and how does it work?

#### Terraform
- What is Terraform state? Where do you store it?
- What happens if state file is lost?
- terraform plan vs terraform apply?
- What are Terraform modules?
- How do you handle sensitive data in Terraform?
- What is state locking and why is it needed?

#### Git
- What is your branching strategy?
- How do you resolve merge conflicts?
- What is git rebase vs merge?
- How do you revert a bad commit in production?

### 🔨 Interview Prep Tasks
- [ ] Practice explaining YOUR project (2-minute version)
- [ ] Practice explaining YOUR pipeline (2-minute version)
- [ ] Draw architecture diagrams on paper (practice for whiteboard)
- [ ] Mock interview with a friend
- [ ] Update your LinkedIn with DevOps keywords
- [ ] Update resume — highlight DevOps project prominently

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 📚 ALL RESOURCES IN ONE PLACE
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### 🎥 YouTube Playlists & Courses (FREE)

| Topic | Resource | Type |
|-------|----------|------|
| DevOps Full | Abhishek Veeramalla — "DevOps Zero to Hero" playlist | YouTube |
| AWS Full | Abhishek Veeramalla — "AWS Zero to Hero" 30-day playlist | YouTube |
| Docker | TechWorld with Nana — "Docker Tutorial 3 Hours" | YouTube |
| Docker Compose | TechWorld with Nana — "Ultimate Docker Compose Tutorial" | YouTube |
| Kubernetes | TechWorld with Nana — "K8s Full Course" | YouTube |
| Terraform | TechWorld with Nana — "Terraform Complete Tutorial" | YouTube |
| GitHub Actions | TechWorld with Nana — "GitHub Actions Tutorial" | YouTube |
| Jenkins | Abhishek Veeramalla — "Jenkins Zero to Hero" | YouTube |
| Linux | KodeKloud — "Linux Crash Course for Beginners" | YouTube + Labs |
| K8s Labs | KodeKloud — "Kubernetes Crash Course" with free labs | Web + YouTube |
| Terraform Cert | FreeCodeCamp — "Terraform Associate Course" (7hrs) | YouTube |
| Shell Scripting | Abhishek Veeramalla — "Shell Scripting" playlist | YouTube |

### 🌐 Websites & Documentation (FREE)

| Resource | URL | Use For |
|----------|-----|---------|
| AWS Free Tier | https://aws.amazon.com/free | Practice AWS services |
| Docker Docs | https://docs.docker.com | Reference |
| K8s Docs | https://kubernetes.io/docs | Reference |
| Terraform Learn | https://developer.hashicorp.com/terraform/tutorials | Guided tutorials |
| GitHub Actions Docs | https://docs.github.com/en/actions | Reference |
| KodeKloud Free Labs | https://kodekloud.com | Hands-on practice |
| Play with Docker | https://labs.play-with-docker.com | Browser-based Docker |
| Play with K8s | https://labs.play-with-k8s.com | Browser-based K8s |
| Abhishek GitHub | https://github.com/iam-veeramalla/aws-devops-zero-to-hero | Notes + Projects |

### 💰 Paid (Worth It If You Can Afford)

| Resource | Cost | Why |
|----------|------|-----|
| KodeKloud Subscription | ~₹500-800/month | Best hands-on labs for CKA/CKAD prep |
| Stephane Maarek (Udemy) | ₹400-500 on sale | Best AWS courses, certification focused |
| Mumshad (KodeKloud/Udemy) | ₹400-500 on sale | Best K8s + CKA course |

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 📊 PROGRESS TRACKER
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Overall Progress

| Week | Topic | Dates | Status |
|------|-------|-------|--------|
| 1 | Linux Basics | June 22 – June 28 | 🟡 In Progress |
| 2 | Shell Scripting & Networking | June 29 – July 5 | ⬜ Not Started |
| 3 | Docker Fundamentals | July 6 – July 12 | ⬜ Not Started |
| 4 | Docker Compose & Advanced | July 13 – July 19 | ⬜ Not Started |
| 5 | CI/CD GitHub Actions | July 20 – July 26 | ⬜ Not Started |
| 6 | Jenkins + Advanced CI/CD | July 27 – Aug 2 | ⬜ Not Started |
| 7 | AWS Core (IAM, EC2, VPC, S3) | Aug 3 – Aug 9 | ⬜ Not Started |
| 8 | AWS DevOps (ECS, ECR, ALB, RDS) | Aug 10 – Aug 16 | ⬜ Not Started |
| 9 | Kubernetes Fundamentals | Aug 17 – Aug 23 | ⬜ Not Started |
| 10 | Kubernetes Advanced + Project | Aug 24 – Aug 30 | ⬜ Not Started |
| 11 | Terraform (IaC) | Aug 31 – Sept 6 | ⬜ Not Started |
| 12 | Complete Project Integration | Sept 7 – Sept 13 | ⬜ Not Started |
| 13 | Interview Preparation | Sept 14 – Sept 21 | ⬜ Not Started |

### Status Legend
- ⬜ Not Started
- 🟡 In Progress
- ✅ Completed

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 💡 TIPS FOR SUCCESS
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Do's ✅
1. **Hands-on first** — Always practice what you watch
2. **One project, many tools** — Use same Spring Boot app throughout
3. **GitHub is your resume** — Push everything with good READMEs
4. **Consistency > Intensity** — 1.5 hrs daily beats 10 hrs on weekend
5. **Document your struggles** — Blog about what you learned (LinkedIn/Medium)
6. **Network** — Follow DevOps people on LinkedIn/Twitter, comment on their posts
7. **Apply early** — Start applying from Week 10, don't wait till "perfect"

### Don'ts ❌
1. **Don't tutorial hop** — Stick to Abhishek + Nana, don't keep switching
2. **Don't skip hands-on** — Watching without doing = waste of time
3. **Don't learn everything** — Focus on the tools in this plan only
4. **Don't buy expensive courses** — Free YouTube is more than enough
5. **Don't memorize** — Understand concepts, you can Google syntax
6. **Don't compare** — Everyone's pace is different, focus on your progress

### Your Advantage as a Java Developer 🎯
- You already understand application architecture
- You know how Spring Boot apps work (most DevOps engineers don't)
- You understand databases, APIs, and backend systems
- In interviews, you can explain BOTH the application AND the infrastructure
- Companies LOVE developers who understand ops — you'll be "DevOps + Developer"

---

## 🎯 FINAL GOAL

By September 19, 2026, you should be able to:

1. ✅ Explain DevOps culture and practices
2. ✅ Containerize any Java application with Docker
3. ✅ Build CI/CD pipelines (GitHub Actions + Jenkins)
4. ✅ Deploy applications on AWS (ECS, EC2)
5. ✅ Work with Kubernetes (deploy, scale, troubleshoot)
6. ✅ Write Infrastructure as Code with Terraform
7. ✅ Have ONE solid project on GitHub that demonstrates ALL of this
8. ✅ Answer 90% of DevOps interview questions confidently

---

**Start today. Not tomorrow. TODAY.**
**Open YouTube → Search "Abhishek Veeramalla DevOps Zero to Hero Day 1" → START.**

Good luck! 🚀
