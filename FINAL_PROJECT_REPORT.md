# Enterprise DevOps Platform

## Final Project Report

**Project:** Design and Development of a Complete Enterprise DevOps
Ecosystem with Cloud Infrastructure, Automation, Security, Monitoring,
Reliability and Self-Healing Capabilities

**Repository:** https://github.com/karthi0079/enterprise-devops

**Date:** August 2026

------------------------------------------------------------------------

## 1. Executive Summary

This project implements a practical DevOps ecosystem covering cloud
infrastructure provisioning, Infrastructure as Code, containerization,
CI/CD automation, security scanning, container registry management,
monitoring, centralized application logging, and Kubernetes
self-healing.

AWS infrastructure is provisioned using Terraform. The application is
containerized with Docker and published to GitHub Container Registry
(GHCR). GitHub Actions automates image building, application testing,
Trivy vulnerability scanning, image publishing, and deployment to an AWS
EC2 instance.

CloudWatch is used for EC2 monitoring and application log collection.
Kubernetes/Minikube is used to demonstrate orchestration, service
exposure, two-replica deployment, and automatic pod recovery.

The implementation was tested successfully through AWS, Docker, GitHub
Actions, CloudWatch, and Kubernetes.

------------------------------------------------------------------------

## 2. Project Objectives

The project was designed to demonstrate the following DevOps
capabilities:

-   Cloud infrastructure provisioning using Terraform
-   AWS networking and compute configuration
-   Infrastructure as Code validation and version control
-   Docker-based application containerization
-   Automated CI/CD using GitHub Actions
-   Container vulnerability scanning using Trivy
-   Container image management using GHCR
-   Automated deployment to AWS EC2
-   CloudWatch monitoring and centralized container logging
-   Kubernetes deployment and service management
-   Kubernetes self-healing using multiple replicas
-   Cost-conscious cloud architecture
-   Technical documentation and operational evidence

------------------------------------------------------------------------

## 3. Technology Stack

  Category                 Technology
  ------------------------ ---------------------------------------------------
  Cloud                    AWS
  Infrastructure as Code   Terraform
  Compute                  Amazon EC2
  Networking               VPC, Public Subnet, Internet Gateway, Route Table
  Security                 IAM Role, Security Group, Trivy
  Containerization         Docker
  Container Registry       GitHub Container Registry
  CI/CD                    GitHub Actions
  Monitoring               Amazon CloudWatch
  Logging                  CloudWatch Logs
  Orchestration            Kubernetes
  Local Kubernetes         Minikube
  Source Control           Git / GitHub
  Operating System         Linux / Windows development environment

------------------------------------------------------------------------

## 4. High-Level Architecture

``` text
                         Developer
                             |
                             v
                    +----------------+
                    | GitHub Repo    |
                    +-------+--------+
                            |
                            v
                    +----------------+
                    | GitHub Actions |
                    | Build          |
                    | Test           |
                    | Trivy Scan     |
                    +-------+--------+
                            |
                            v
                    +----------------+
                    |      GHCR      |
                    | Container      |
                    | Registry       |
                    +-------+--------+
                            |
                            v
              +--------------------------------+
              |            AWS VPC              |
              |                                |
              |       Public Subnet            |
              |             |                  |
              |             v                  |
              |        +----------+            |
              |        |   EC2    |            |
              |        |  Docker  |            |
              |        +----+-----+            |
              |             |                  |
              |             v                  |
              |        Application             |
              |                                |
              |        +------------+          |
              |        | CloudWatch |          |
              |        | Alarms/Logs|          |
              |        +------------+          |
              +--------------------------------+

                  Local Kubernetes
                         |
                         v
                  +-------------+
                  | Deployment  |
                  | 2 Replicas  |
                  +------+------+
                         |
                   +-----+-----+
                   |           |
                   v           v
                 Pod 1       Pod 2
                   \           /
                    \         /
                     v       v
                    NodePort
```

------------------------------------------------------------------------

## 5. AWS Infrastructure

### 5.1 VPC

The project uses an AWS VPC with the CIDR block:

`10.0.0.0/16`

The VPC provides isolated networking for the EC2 application
environment.

### 5.2 Public Subnet

The EC2 instance is deployed in a public subnet:

-   Subnet CIDR: `10.0.1.0/24`
-   Public IP assignment: enabled
-   Internet connectivity: through the Internet Gateway

### 5.3 Internet Gateway

An Internet Gateway is attached to the VPC to provide internet
connectivity for the public subnet.

### 5.4 Route Table

The public route table contains:

  Destination     Target
  --------------- ------------------
  `10.0.0.0/16`   local
  `0.0.0.0/0`     Internet Gateway

### 5.5 EC2

The application is hosted on an EC2 instance running Docker.

The instance uses an IAM role and a Security Group. The deployed
application was successfully accessed through HTTP.

### 5.6 Security Group

The application Security Group allows:

  Protocol     Port Source        Purpose
  ---------- ------ ------------- ---------
  TCP            22 `0.0.0.0/0`   SSH
  TCP            80 `0.0.0.0/0`   HTTP

For a production deployment, SSH should be restricted to trusted source
IPs or replaced with a managed access mechanism.

------------------------------------------------------------------------

## 6. Infrastructure as Code

Terraform is used to manage the AWS infrastructure.

The Terraform configuration is organized into:

-   `vpc.tf` --- VPC and networking
-   `ec2.tf` --- EC2 compute configuration
-   `iam.tf` --- IAM configuration
-   `monitoring.tf` --- CloudWatch alarms and log group
-   `variables.tf` --- project variables
-   `outputs.tf` --- infrastructure outputs
-   `provider.tf` --- AWS provider configuration

Terraform was used to validate, plan, apply, and manage infrastructure
changes.

------------------------------------------------------------------------

## 7. Docker Containerization

The application is packaged as a Docker image.

The Docker image contains the web application and exposes port 80.

The container was successfully deployed to EC2 using:

-   GHCR image
-   Port mapping `80:80`
-   Restart policy `unless-stopped`

The final container was configured with the Docker `awslogs` logging
driver so application logs are sent to CloudWatch Logs.

------------------------------------------------------------------------

## 8. CI/CD Pipeline

GitHub Actions provides the automated CI/CD pipeline.

### Pipeline Flow

``` text
Git Push
   |
   v
Checkout
   |
   v
Docker Build
   |
   v
Application Test
   |
   v
Trivy Security Scan
   |
   v
Login to GHCR
   |
   v
Push Image
   |
   v
SSH Deployment to EC2
   |
   v
Pull Latest Image
   |
   v
Run Docker Container
```

### CI/CD Stages

1.  Checkout source code
2.  Build Docker image
3.  Run the application container for testing
4.  Test the HTTP endpoint
5.  Run Trivy security scanning
6.  Authenticate with GHCR
7.  Push SHA-tagged image
8.  Push the `latest` image
9.  Connect to EC2 using SSH
10. Pull the latest image
11. Replace the previous application container
12. Start the new container with automatic restart and CloudWatch
    logging

The workflow uses GitHub Actions Secrets for deployment credentials.

------------------------------------------------------------------------

## 9. DevSecOps and Trivy

Trivy is integrated into the CI/CD pipeline.

The image is scanned for:

-   HIGH vulnerabilities
-   CRITICAL vulnerabilities

The pipeline uses a security gate so matching vulnerabilities can stop
the workflow.

During development, vulnerabilities were identified in Alpine/OpenSSL
packages. The scan output also identified fixed package versions,
demonstrating the use of vulnerability scanning as part of the
development lifecycle.

The security scan was successfully incorporated into the GitHub Actions
workflow.

------------------------------------------------------------------------

## 10. GitHub Container Registry

GitHub Container Registry is used to store the application image.

Image:

`ghcr.io/karthi0079/enterprise-devops/enterprise-devops-app`

The pipeline publishes both:

-   Commit SHA image tag
-   `latest` image tag

The EC2 instance successfully pulled the image from GHCR before
deployment.

------------------------------------------------------------------------

## 11. Monitoring and Logging

Amazon CloudWatch is used for infrastructure monitoring and application
logging.

### CloudWatch Alarms

Two alarms were configured:

#### CPU High Alarm

-   Metric: `CPUUtilization`
-   Threshold: 80%
-   Evaluation periods: 2
-   Period: 5 minutes

#### EC2 Status Check Alarm

-   Metric: `StatusCheckFailed`
-   Threshold: greater than 0
-   Evaluation periods: 2
-   Period: 5 minutes

Both alarms reached the `OK` state after CloudWatch received sufficient
metric data.

### Application Logs

A CloudWatch log group was created:

`enterprise-devops-application`

Retention is configured for 7 days.

The EC2 Docker container uses the `awslogs` driver and sends application
logs to CloudWatch.

------------------------------------------------------------------------

## 12. Kubernetes Deployment

Kubernetes was demonstrated locally using Minikube to avoid the
additional cost of Amazon EKS.

### Deployment

The application uses a Kubernetes Deployment with:

-   2 replicas
-   Container port 80
-   Resource requests and limits

### Service

A NodePort Service exposes the application:

-   Service port: 80
-   Target port: 80
-   NodePort: 30080

### Verification

The deployment successfully reported:

`2/2` replicas available.

Both application pods reached the `Running` state.

------------------------------------------------------------------------

## 13. Self-Healing Demonstration

Kubernetes self-healing was explicitly tested.

Both application pods were deleted using:

``` bash
kubectl delete pod -l app=enterprise-devops-app
```

Kubernetes automatically created replacement pods.

The resulting state showed two new pods in the `Running` state.

This demonstrates that the Deployment controller continuously maintains
the desired replica count.

### Result

``` text
Desired replicas:   2
Available replicas: 2
Self-healing:       Successful
```

------------------------------------------------------------------------

## 14. Reliability

The project demonstrates reliability through multiple mechanisms:

-   Docker `restart: unless-stopped`
-   Kubernetes Deployment with two replicas
-   Kubernetes automatic pod recreation
-   EC2 status monitoring
-   CloudWatch alarms
-   Infrastructure recreation through Terraform
-   Version-controlled application and infrastructure configuration

The Kubernetes failure test provided direct evidence of automated
recovery at the application orchestration layer.

------------------------------------------------------------------------

## 15. Disaster Recovery Strategy

The application is stateless and does not use a database.

Recovery can be performed by:

1.  Recreating the AWS infrastructure with Terraform.
2.  Pulling the application image from GHCR.
3.  Starting the Docker container.
4.  Verifying the HTTP endpoint.
5.  Restoring monitoring and logging configuration.

The source code and Terraform configuration are maintained in GitHub.

Automated database backup and cross-region disaster recovery were not
implemented because the current application does not contain persistent
database data.

### Future Production Improvements

-   EBS snapshots
-   S3 backup storage
-   Cross-region recovery
-   Database backup and point-in-time recovery
-   Automated disaster recovery testing
-   Infrastructure multi-AZ architecture

------------------------------------------------------------------------

## 16. Cost Optimization

The project intentionally avoids unnecessary AWS services.

Cost-conscious decisions include:

-   Single EC2 instance
-   Public subnet instead of requiring a NAT Gateway
-   No NAT Gateway
-   No Application Load Balancer
-   No RDS
-   No EKS
-   Local Minikube for Kubernetes demonstration
-   7-day CloudWatch log retention
-   No unnecessary production-scale managed services

This approach provides the required DevOps demonstrations while
minimizing recurring AWS costs.

------------------------------------------------------------------------

## 17. Testing and Validation

The following tests were successfully performed.

### Infrastructure

-   Terraform validation
-   Terraform plan
-   Terraform apply
-   AWS VPC verification
-   Route table verification
-   Internet Gateway verification
-   Security Group verification
-   EC2 verification

### Application

-   Docker image build
-   Container execution
-   HTTP application test
-   EC2 application access

### CI/CD

-   GitHub Actions workflow execution
-   Docker build
-   Application test
-   Trivy scan
-   GHCR push
-   EC2 deployment

### Monitoring

-   CPU CloudWatch alarm
-   EC2 status check alarm
-   CloudWatch log group
-   Docker `awslogs` driver

### Kubernetes

-   Minikube node readiness
-   Deployment creation
-   Two replicas
-   NodePort service
-   Application access
-   Pod deletion
-   Automatic pod recreation

------------------------------------------------------------------------

## 18. Evidence and Screenshots

The following screenshots should be included with the final submission:

### AWS Infrastructure

-   Terraform apply result
-   VPC and subnet
-   Route table
-   Internet Gateway
-   EC2 instance
-   Security Group
-   Successful application response

### CI/CD

-   GitHub Actions successful workflow
-   Docker build/test stage
-   Trivy scan
-   GHCR package/image
-   Successful deployment stage

### Monitoring

-   CloudWatch CPU alarm showing `OK`
-   CloudWatch status check alarm showing `OK`
-   CloudWatch log group
-   Docker logging configuration

### Kubernetes

-   `kubectl get nodes`
-   `kubectl get pods`
-   `kubectl get deployment`
-   `kubectl get service`
-   Pod deletion/self-healing demonstration
-   Successful Kubernetes application response

------------------------------------------------------------------------

## 19. Project Repository Structure

``` text
enterprise-devops/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── app/
│   ├── Dockerfile
│   └── index.html
├── terraform/
│   ├── ec2.tf
│   ├── iam.tf
│   ├── monitoring.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── vpc.tf
├── kubernetes/
│   ├── deployment.yaml
│   └── service.yaml
├── monitoring/
├── security/
│   └── trivy.md
├── docs/
│   ├── architecture.md
│   ├── network.md
│   └── disaster-recovery.md
└── README.md
```

------------------------------------------------------------------------

## 20. Conclusion

The Enterprise DevOps Platform successfully demonstrates an end-to-end
DevOps workflow.

Infrastructure is managed using Terraform, the application is
containerized using Docker, and GitHub Actions automates build, test,
security scanning, image publishing, and EC2 deployment.

Trivy introduces security scanning into the CI/CD lifecycle. GHCR
provides container image storage. CloudWatch provides infrastructure
monitoring and centralized application logging.

Kubernetes/Minikube demonstrates orchestration using two replicas and
successfully proves self-healing through automatic pod recreation after
deliberate pod deletion.

The resulting architecture provides a practical, reproducible,
version-controlled, and cost-conscious DevOps implementation suitable
for demonstrating cloud infrastructure, automation, DevSecOps,
observability, and reliability concepts.

------------------------------------------------------------------------

## 21. Final Status

  Capability                Status
  ------------------------- ---------------------
  AWS Infrastructure        Completed
  Terraform IaC             Completed
  Docker Containerization   Completed
  GitHub Actions CI/CD      Completed
  Trivy Security Scanning   Completed
  GHCR Registry             Completed
  EC2 Deployment            Completed
  CloudWatch Monitoring     Completed
  CloudWatch Logging        Completed
  Kubernetes Deployment     Completed
  Two-Replica Deployment    Completed
  Kubernetes Self-Healing   Tested Successfully
  Documentation             Completed
  Screenshots/Evidence      Captured
