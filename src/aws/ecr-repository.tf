resource "aws_ecr_repository" "main" {

  for_each = toset(var.repository_list)

  name                 = "ecr-${var.application_name}-${var.environment_name}-${each.value}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = {
    application = var.application_name
    environment = var.environment_name
  }

}