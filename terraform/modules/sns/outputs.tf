output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "ssm_param_name" {
  value = aws_ssm_parameter.slack_webhook.name
}
