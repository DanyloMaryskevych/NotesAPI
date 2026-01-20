variable "name_prefix" {
  type        = string
  description = "Global resource name prefix (e.g. myapp-prod)"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where networking resources (ALB, ECS, RDS) will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs used for load balancers"
}

variable "application_port" {
  type        = number
  description = "Port on which the application container listens"
}

variable "health_check_path" {
  type        = string
  description = "HTTP path used by the load balancer health check"
  default     = "/"
}
