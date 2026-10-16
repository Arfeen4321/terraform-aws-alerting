terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-${var.environment}-alerts"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 2. Email Subscription
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# 3. CPU Alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count               = (var.alert_type == "CPU" || var.alert_type == "ALL") ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period_seconds
  statistic           = "Average"
  threshold           = var.threshold
  alarm_description   = "Alarm when EC2 CPU exceeds ${var.threshold}%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    MetricType  = "CPU"
  }
}

# 4. Status Check Failed Alarm (EC2 hardware/system health)
resource "aws_cloudwatch_metric_alarm" "status_check" {
  count               = (var.alert_type == "STATUS_CHECK" || var.alert_type == "ALL") ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Alarm when EC2 status check fails"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    MetricType  = "StatusCheck"
  }
}

# 5. Memory Alarm (CloudWatch Agent metric)
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  count               = (var.alert_type == "MEMORY" || var.alert_type == "ALL") ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = var.period_seconds
  statistic           = "Average"
  threshold           = var.threshold
  alarm_description   = "Alarm when Memory exceeds ${var.threshold}%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    MetricType  = "Memory"
  }
}

# 6. Disk Alarm (CloudWatch Agent metric)
resource "aws_cloudwatch_metric_alarm" "high_disk" {
  count               = (var.alert_type == "DISK" || var.alert_type == "ALL") ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-high-disk"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = var.period_seconds
  statistic           = "Average"
  threshold           = var.threshold
  alarm_description   = "Alarm when Disk exceeds ${var.threshold}%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    MetricType  = "Disk"
  }
}
