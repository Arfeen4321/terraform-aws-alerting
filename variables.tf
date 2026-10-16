variable "project_name" {
  description = "Name of the project (e.g. warehouse, payment, auth)"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "alert_email" {
  description = "Email address to receive alerts"
  type        = string
}

variable "instance_id" {
  description = "EC2 Instance ID to monitor"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU percentage threshold to trigger alarm"
  type        = number
  default     = 80
}

variable "evaluation_periods" {
  description = "Number of periods to evaluate"
  type        = number
  default     = 2
}

variable "period_seconds" {
  description = "The period in seconds over which the statistic is applied"
  type        = number
  default     = 60
}
