variable "name_prefix" {
  type        = string
  description = "Global resource name prefix (e.g. myapp-prod)"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the RDS instance will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the RDS subnet group (typically private subnets)"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class (e.g. db.t3.micro, db.t4g.small)"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage size for the database in GB"
  default     = 20
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain automated database backups"
  default     = 7
}

variable "username" {
  type        = string
  description = "Master username for the database"
  default     = "postgres"
}

variable "db_name" {
  type        = string
  description = "Initial database name to create on the RDS instance"
}
