# Enterprise DevOps Platform

## Overview

A cost-conscious DevOps project implementing infrastructure automation, containerization, CI/CD, security scanning, monitoring, and Kubernetes deployment.

## Architecture

GitHub → GitHub Actions → Trivy → GHCR → AWS EC2 → Docker → Application

CloudWatch provides EC2 monitoring and application logging.

Kubernetes/Minikube provides a local deployment with two replicas and self-healing.

## Technologies

- AWS
- Terraform
- Docker
- GitHub Actions
- GitHub Container Registry
- Trivy
- CloudWatch
- Kubernetes
- Minikube
- Linux

## AWS Infrastructure

- VPC
- Public subnet
- Internet Gateway
- Route table
- Security Group
- EC2 instance
- IAM role

## CI/CD

The GitHub Actions pipeline performs:

1. Docker image build
2. Application test
3. Trivy security scan
4. Push to GHCR
5. Deployment to EC2

## Monitoring

CloudWatch monitors:

- EC2 CPU utilization
- EC2 status checks
- Application Docker logs

Log retention is configured for 7 days.

## Kubernetes

The application is deployed using:

- Kubernetes Deployment
- 2 replicas
- NodePort Service
- Automatic pod recreation/self-healing

## Security

- IAM role for EC2
- Security Group controls
- Trivy vulnerability scanning
- GHCR container registry
- No credentials committed to the repository

## Cost Optimization

- Single EC2 instance
- 30 GB gp3 storage
- No NAT Gateway
- No Application Load Balancer
- No RDS
- No EKS
- Local Minikube for Kubernetes demonstration
- CloudWatch logs retained for 7 days

## Result

The application was successfully deployed to AWS EC2 using Docker and automated through GitHub Actions. Kubernetes deployment and self-healing were also successfully demonstrated using Minikube.# CI/CD deployment verified
