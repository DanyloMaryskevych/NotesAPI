module "sns" {
  source = "../../modules/sns"

  name_prefix = local.name_prefix

  lambda_arn = module.lambda.lambda_arn

  ssm_webhook_param_name = local.slack_webhook_param
}

module "lambda" {
  source = "../../modules/lambda"

  region      = var.region
  name_prefix = local.name_prefix

  ssm_webhook_param_name = local.slack_webhook_param
}