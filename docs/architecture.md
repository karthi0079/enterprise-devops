# System Architecture

## Overview

The Enterprise DevOps platform combines AWS infrastructure, Terraform, Docker, GitHub Actions, GitHub Container Registry, Trivy, CloudWatch, and Kubernetes.

## Architecture Flow

Developer
↓
GitHub Repository
↓
GitHub Actions
↓
Build → Test → Trivy Security Scan
↓
GitHub Container Registry
↓
AWS EC2
↓
Docker Container
↓
Enterprise DevOps Application

CloudWatch monitors the EC2 instance and stores application container logs.

Local Kubernetes/Minikube provides a second deployment model with two application replicas and automatic pod recovery.

## Main Components

- AWS VPC and public subnet
- Internet Gateway and route table
- EC2 instance
- IAM role and Security Group
- Docker
- GitHub Actions
- GitHub Container Registry
- Trivy
- CloudWatch alarms and logs
- Kubernetes Deployment and NodePort Service
- Minikube for local orchestration

## Deployment Flow

1. Developer pushes code to GitHub.
2. GitHub Actions builds the Docker image.
3. The application container is tested.
4. Trivy scans the image for vulnerabilities.
5. The image is pushed to GHCR.
6. GitHub Actions connects to EC2.
7. The latest image is deployed using Docker.
8. CloudWatch receives application logs.