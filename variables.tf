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
  description = "Type of alert: CPU, DISK, MEMORY, STATUS_CHECK, ALL"
  default     = "ALL"
}

variable "threshold" {
  type        = number
  description = "Threshold percentage"
  default     = 75
}

variable "evaluation_periods" {
  type    = number
  default = 2
}

variable "period_seconds" {
  type    = number
  default = 60
}
