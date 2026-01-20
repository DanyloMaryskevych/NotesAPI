variable "name_prefix" {
  type        = string
  description = "Global resource name prefix (e.g. myapp-prod)"
}

variable "lambda_arn" {
  type        = string
  description = "Slack notifier Lambda ARN"
}

variable "ssm_webhook_param_name" {
  type        = string
  description = "SSM parameter name where Slack webhook will be stored (SecureString)"
}
