variable "region" {
  type        = string
  description = "AWS region where resources will be created"
}

variable "name_prefix" {
  type        = string
  description = "Global resource name prefix (e.g. myapp-prod)"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "application_name" {
  type        = string
  description = "Application name (api, backend, worker, etc)"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the ECS service is deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for ECS service networking (typically private subnets)"
}

variable "application_port" {
  type        = number
  description = "Port exposed by the container and registered in the target group"
}

variable "cpu" {
  type        = number
  description = "CPU units allocated to the ECS task (e.g. 256 = 0.25 vCPU)"
  default     = 256
}

variable "memory" {
  type        = number
  description = "Memory (in MiB) allocated to the ECS task"
  default     = 512
}

variable "desired_count" {
  type        = number
  description = "Number of desired ECS task replicas to run"
  default     = 1
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL (without tag)"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB target group used by the ECS service"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain application logs in CloudWatch Logs"
  default     = 14
}

variable "db_resource_id" {
  type        = string
  description = "RDS resource ID used for IAM database authentication"
}

variable "db_username" {
  type        = string
  description = "Database username used by the application to connect to the database"
}

variable "db_host" {
  type        = string
  description = "RDS endpoint hostname"
}

variable "db_name" {
  type        = string
  description = "Database name"
}
