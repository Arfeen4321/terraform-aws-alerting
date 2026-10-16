output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.alerts.arn
}

output "cpu_alarm_id" {
  description = "ID of the High CPU alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu.id
}
