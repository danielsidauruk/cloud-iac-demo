data "aws_iam_policy_document" "ecr_image_pusher_assume_role" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.ecr_image_pushers}"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecr_image_pusher" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = [for repo in aws_ecr_repository.main : repo.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }
}

resource "aws_iam_role" "ecr_image_pusher" {
  name               = "${var.application_name}-${var.environment_name}-ecr-image-pushers"
  assume_role_policy = data.aws_iam_policy_document.ecr_image_pusher_assume_role.json
}

resource "aws_iam_policy" "ecr_image_pusher" {
  name   = "${var.application_name}-${var.environment_name}-ecr-image-pusher"
  policy = data.aws_iam_policy_document.ecr_image_pusher.json
}

resource "aws_iam_role_policy_attachment" "ecr_image" {
  policy_arn = aws_iam_policy.ecr_image_pusher.arn
  role       = aws_iam_role.ecr_image_pusher.name
}
