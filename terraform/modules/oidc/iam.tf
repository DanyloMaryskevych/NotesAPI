resource "aws_iam_role" "github_actions" {
  name = "${var.name_prefix}-github-actions-ecs-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Federated = var.github_oidc_provider_arn
        }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:${var.github_ref}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_actions_staging" {
  name = "${var.name_prefix}-github-actions-ecs-policy"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        #        Resource = module.ecr.repository_arn
        Resource = var.ecr_repository_arn
      },

      {
        Effect = "Allow"
        Action = [
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ]
        Resource = [
          #          module.ecs.cluster_arn,
          var.ecs_cluster_arn,
          #          module.ecs.service_arn
          var.ecs_service_arn
        ]
      },

      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = [
          #          module.ecs.task_exec_role_arn,
          var.ecs_task_exec_role_arn,
          #          module.ecs.task_role_arn,
          var.ecs_task_role_arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_staging" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_staging.arn
}
