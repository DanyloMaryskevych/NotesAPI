variable "name_prefix" {
  type        = string
  description = "Global resource name prefix (e.g. myapp-prod)"
}

variable "alb_name" {
  type        = string
  description = "ALB name"
}

variable "alb_dns_name" {
  type        = string
  description = "ALB DNS name to use as CloudFront origin"
}

variable "hosted_zone" {
  type        = string
  description = "Route53 hosted zone domain name (e.g. example.com)"
}

variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID"
}

variable "subdomain" {
  type        = string
  description = "Subdomain to create or manage within the hosted zone (e.g. api, app, www)"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM cert ARN (must be in us-east-1)"
}

variable "price_class" {
  type        = string
  description = "CloudFront price class"
  default     = "PriceClass_100"
}

variable "web_acl_arn" {
  type        = string
  description = "WAF Web ACL ARN"
}
