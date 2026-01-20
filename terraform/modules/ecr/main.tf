resource "aws_ecr_repository" "this" {
  name                 = "${var.environment}/${var.application_name}"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = templatefile(
    "${path.module}/lifecycle-policy.json",
    {
      max_image_count = var.max_image_count
    }
  )
}
