variable "name_prefix" {
  type        = string
  description = "Global resource name prefix (e.g. myapp-prod)"
}

variable "rate_limit" {
  type        = number
  description = "Requests per 5 minutes per IP for current API version (AWS WAF minimum is 10, maximum is 2000000000)"
  default     = 1000

  validation {
    condition     = var.rate_limit >= 10 && var.rate_limit <= 2000000000
    error_message = "rate_limit must be between 10 and 2000000000 (AWS WAF requirement)"
  }
}

variable "previous_version_rate_limit" {
  type        = number
  description = "Requests per 5 minutes per IP for previous API version (AWS WAF minimum is 10, maximum is 2000000000)"
  default     = 10

  validation {
    condition     = var.previous_version_rate_limit >= 10 && var.previous_version_rate_limit <= 2000000000
    error_message = "previous_version_rate_limit must be between 10 and 2000000000 (AWS WAF requirement)"
  }
}

variable "previous_version_path_pattern" {
  type        = string
  description = "URL path pattern to identify previous API version requests (e.g., '/v1/*' or '/api/v1/*')"
  default     = "/v1/*"
}
