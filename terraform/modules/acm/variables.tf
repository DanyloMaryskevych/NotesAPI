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
