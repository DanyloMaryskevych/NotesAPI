variable "region" {
  type        = string
  description = "AWS region where resources will be created"
}

variable "name_prefix" {
  type        = string
  description = "Global name prefix (e.g. omnisent-staging)"
}

variable "ssm_webhook_param_name" {
  type        = string
  description = "SSM parameter name (SecureString) that stores Slack webhook URL"
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch Logs retention for the Lambda log group"
  default     = 14
}
