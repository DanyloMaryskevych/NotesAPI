variable "name_prefix" {
  type        = string
  description = "Global resource name prefix (e.g. myapp-prod)"
}

variable "github_org" {
  type        = string
  description = "GitHub organization or user that owns the repository (e.g. my-org or my-username)"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name that is allowed to assume the IAM role via OIDC"
}

variable "github_ref" {
  type        = string
  description = "Git reference allowed to assume the role (e.g. refs/heads/main, refs/tags/*)"
}

variable "github_oidc_provider_arn" {
  type        = string
  description = "ARN of the GitHub Actions OIDC provider"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "ARN of the ECS task role assumed by the running application container"
}

variable "ecs_task_exec_role_arn" {
  type        = string
  description = "ARN of the ECS task execution role used by ECS to pull images and write logs"
}

variable "ecs_service_arn" {
  type        = string
  description = "ARN of the ECS service that GitHub Actions is allowed to deploy or update"
}

variable "ecs_cluster_arn" {
  type        = string
  description = "ARN of the ECS cluster where the target service is running"
}

variable "ecr_repository_arn" {
  type        = string
  description = "ARN of the ECR repository that GitHub Actions is allowed to push images to"
}
