output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.alerts.arn
}

output "cpu_alarm_id" {
  description = "ID of the High CPU alarm"
  value       = try(aws_cloudwatch_metric_alarm.high_cpu[0].id, null)
}

output "status_check_alarm_id" {
  description = "ID of Status Check alarm"
  value       = try(aws_cloudwatch_metric_alarm.status_check[0].id, null)
}
