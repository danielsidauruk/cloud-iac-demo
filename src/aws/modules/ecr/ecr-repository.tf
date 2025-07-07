resource "aws_ecr_repository" "main" {

  for_each = toset(var.repository_list)

  name                 = "ecr-${var.application_name}-${var.environment_name}-${each.value}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-ecr"
    application = var.application_name
    environment = var.environment_name
  }

}

resource "aws_ecr_lifecycle_policy" "main" {
  for_each   = toset(var.repository_list)
  repository = aws_ecr_repository.main[each.value].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1,
      description  = "Expire untagged images older than 30 days"
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = 30
      }
      action = {
        type = "expire"
      }
    }]
  })
}