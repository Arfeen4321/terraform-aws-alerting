variable "project_name" {
  type    = string
  default = "warehouse"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "alert_email" {
  type = string
}

variable "instance_id" {
  type = string
}

variable "alert_type" {
  type        = string
  description = "Type of alert: CPU, STATUS_CHECK, or ALL"
  default     = "ALL"
}

variable "cpu_threshold" {
  type    = number
  default = 75
}

variable "evaluation_periods" {
  type    = number
  default = 2
}

variable "period_seconds" {
  type    = number
  default = 60
}
