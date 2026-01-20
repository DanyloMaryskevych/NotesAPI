variable "environment" {
  type        = string
  description = "Environment name (dev, stage, prod)"
}

variable "application_name" {
  type        = string
  description = "Application name (api, backend, worker, etc)"
}

variable "image_tag_mutability" {
  type        = string
  description = "MUTABLE or IMMUTABLE"
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  type        = bool
  description = "Enable image scanning on push"
  default     = true
}

variable "max_image_count" {
  type        = number
  description = "Maximum number of container images to retain in the ECR repository (older images will be expired by lifecycle policy)"
  default     = 20
}
