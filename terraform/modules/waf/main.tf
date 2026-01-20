resource "aws_wafv2_web_acl" "this" {
  provider = aws.us_east_1

  name  = "${var.name_prefix}-waf"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-waf"
    sampled_requests_enabled   = true
  }

  #
  # 1️⃣ AWS managed common protections
  #
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSCommonRules"
      sampled_requests_enabled   = true
    }
  }

  #
  # 2️⃣ Known bad inputs
  #
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BadInputs"
      sampled_requests_enabled   = true
    }
  }

  #
  # 3️⃣ Rate limiting for previous API version (per IP)
  # Applies lower rate limit to requests matching previous version path pattern
  #
  rule {
    name     = "RateLimitPreviousVersion"
    priority = 10

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.previous_version_rate_limit
        aggregate_key_type = "IP"
        scope_down_statement {
          byte_match_statement {
            positional_constraint = "CONTAINS"
            search_string         = replace(var.previous_version_path_pattern, "/*", "")
            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
            field_to_match {
              uri_path {}
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitPreviousVersion"
      sampled_requests_enabled   = true
    }
  }

  #
  # 4️⃣ Rate limiting for current API version (per IP)
  # Applies higher rate limit to all other requests (current version)
  #
  rule {
    name     = "RateLimitCurrentVersion"
    priority = 11

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit
        aggregate_key_type = "IP"
        scope_down_statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = replace(var.previous_version_path_pattern, "/*", "")
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
                field_to_match {
                  uri_path {}
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitCurrentVersion"
      sampled_requests_enabled   = true
    }
  }
}
