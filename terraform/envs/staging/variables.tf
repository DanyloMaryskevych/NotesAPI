# Global / Environment

variable "region" {
  type        = string
  description = "AWS region where resources will be created"
}

variable "project" {
  type        = string
  description = "Project identifier used for naming and tagging"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, prod)"
}

# VPC

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC (e.g. 10.0.0.0/16)"
}

variable "azs_count" {
  type        = number
  description = "Number of Availability Zones to use when creating subnets"
}

variable "hosted_zone" {
  type        = string
  description = "Route53 hosted zone domain name used for DNS records (e.g. example.com)"
}

# Application

variable "application_name" {
  type        = string
  description = "Logical application or service name"
}

variable "application_port" {
  type        = number
  description = "Port on which the application listens"
}

# DB

variable "db_name" {
  type        = string
  description = "Initial database name"
}

variable "db_username" {
  type        = string
  description = "Database master or application username"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
}

variable "rds_allocated_storage_gb" {
  type        = number
  description = "Allocated RDS storage in GB"
}

variable "rds_min_free_storage_percent" {
  type        = number
  description = "Minimum free storage percentage before alarm"
  default     = 10
}

# OIDC

variable "github_org" {
  type    = string
  default = "Omnisent-Defence"
}

variable "github_repo" {
  type    = string
  default = "API"
}

variable "github_ref" {
  type    = string
  default = "ref:refs/heads/staging"
}

# Defaults

variable "http_port" {
  type        = number
  description = "HTTP port for public-facing services"
  default     = 80
}

variable "https_port" {
  type        = number
  description = "HTTPS port for public-facing services"
  default     = 443
}

variable "postgres_port" {
  type        = number
  description = "PostgreSQL database port"
  default     = 5432
}

variable "github_oidc_url" {
  type        = string
  description = "OIDC provider URL for GitHub Actions"
  default     = "https://token.actions.githubusercontent.com"
}
