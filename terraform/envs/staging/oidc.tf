data "tls_certificate" "github" {
  url = var.github_oidc_url
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = var.github_oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

module "oidc" {
  source = "../../modules/oidc"

  name_prefix = local.name_prefix

  github_org  = var.github_org
  github_ref  = var.github_ref
  github_repo = var.github_repo

  github_oidc_provider_arn = aws_iam_openid_connect_provider.github.arn

  ecs_cluster_arn        = module.ecs.cluster_arn
  ecs_service_arn        = module.ecs.service_arn
  ecs_task_exec_role_arn = module.ecs.task_exec_role_arn
  ecs_task_role_arn      = module.ecs.task_role_arn

  ecr_repository_arn = module.ecr.repository_arn
}

output "github_actions_role_arn" {
  value = module.oidc.github_actions_role_arn
}
