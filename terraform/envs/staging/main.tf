locals {
  tags = {
    Project     = title(var.project)
    Environment = title(var.environment)
    Managed-By  = "Terraform"
  }

  name_prefix = "${var.project}-${var.environment}"

  slack_webhook_param = "/${local.name_prefix}/slack/webhook"

  rds_min_free_storage_bytes = (
  var.rds_allocated_storage_gb * var.rds_min_free_storage_percent / 100
  ) * 1024 * 1024 * 1024
}

module "route53" {
  source = "../../modules/route53"

  domain_name = "${var.project}.${var.hosted_zone}"
}

module "vpc" {
  source = "../../modules/vpc"

  region      = var.region
  name_prefix = local.name_prefix

  cidr_block = var.vpc_cidr
  azs_count  = var.azs_count
}

module "ecr" {
  source = "../../modules/ecr"

  environment = var.environment

  application_name = var.application_name
}
