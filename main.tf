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

# 1. Common SNS Topic for Alerts
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

# 3. CPU Alarm (Only if alert_type == 'CPU' or 'ALL')
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count               = (var.alert_type == "CPU" || var.alert_type == "ALL") ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period_seconds
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "Alarm when EC2 CPU exceeds ${var.cpu_threshold}%"
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

# 4. EC2 Health / Status Check Alarm (Only if alert_type == 'STATUS_CHECK' or 'ALL')
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
  alarm_description   = "Alarm when EC2 instance hardware or system health check fails"
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
