resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.project_name}/application"
  retention_in_days = 7

  tags = {
    Project = var.project_name
  }
}