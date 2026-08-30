# Disaster Recovery Strategy

## Current Implementation

The application is deployed using Terraform and Docker. Infrastructure configuration is maintained in GitHub, allowing the environment to be recreated from Infrastructure as Code.

## Recovery Approach

If the EC2 instance is lost:

1. Recreate the AWS infrastructure using Terraform.
2. Deploy the latest application image from GHCR.
3. Start the Docker container.
4. Verify application availability.
5. Reconfigure monitoring and logging if required.

## Container Recovery

The Docker container uses:

restart: unless-stopped

This allows Docker to automatically restart the application container after a container or Docker service restart.

## Kubernetes Recovery

The Kubernetes Deployment uses two replicas. During testing, both application pods were deleted and Kubernetes automatically created replacement pods.

This demonstrates application-level self-healing.

## Backup Strategy

The current project does not implement automated database or EBS snapshot backups because the application is stateless and does not use a database.

Terraform configuration and application source code are maintained in GitHub.

## Future Improvements

For a production environment, the following could be added:

- Automated EBS snapshots
- S3 backup storage
- Cross-region backup
- Automated disaster recovery testing
- Database backup and point-in-time recovery