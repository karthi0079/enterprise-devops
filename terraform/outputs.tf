output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.app.public_ip
}

output "instance_public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.app.public_dns
}