module "cloudfront" {
  source = "../../modules/cloudfront"

  name_prefix = local.name_prefix

  alb_dns_name = module.alb.dns_name
  alb_name     = module.alb.name
  web_acl_arn  = module.waf.web_acl_arn

  hosted_zone         = var.hosted_zone
  zone_id             = module.route53.zone_id
  subdomain           = var.project
  acm_certificate_arn = module.acm.certificate_arn
}

module "waf" {
  source = "../../modules/waf"

  name_prefix = local.name_prefix

  rate_limit                 = 100
  previous_version_rate_limit = 10
  previous_version_path_pattern = "/v1/*"
}

module "acm" {
  source = "../../modules/acm"

  hosted_zone = var.hosted_zone
  zone_id     = module.route53.zone_id
  subdomain   = var.project
}
