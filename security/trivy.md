# Trivy Security Scanning

## Overview

Trivy is integrated into the GitHub Actions CI/CD pipeline to scan the Docker image for known vulnerabilities.

## Pipeline

Docker Build
↓
Application Test
↓
Trivy Scan
↓
GHCR Push
↓
EC2 Deployment

## Scan Configuration

The pipeline scans for:

- CRITICAL vulnerabilities
- HIGH vulnerabilities

Unfixed vulnerabilities are ignored using the configured Trivy option.

## Security Gate

The Trivy step uses an exit code of 1 when matching vulnerabilities are detected. This prevents vulnerable images from continuing through the deployment pipeline.

## Result

The Docker image was successfully scanned during the CI/CD workflow.

The project also demonstrates remediation by using an updated Alpine base image when vulnerabilities were identified as fixed in a newer package version.

## Security Practices

- Secrets are stored using GitHub Actions Secrets.
- EC2 uses an IAM role.
- Docker images are stored in GHCR.
- Container images are scanned before deployment.
- Infrastructure configuration is maintained through Terraform.