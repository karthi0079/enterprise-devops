resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-cpu-high"
  alarm_description   = "Alert when EC2 CPU is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "status_check" {
  alarm_name          = "${var.project_name}-status-check"
  alarm_description   = "Alert when EC2 status check fails"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "enterprise-devops-application"
  retention_in_days = 7
}