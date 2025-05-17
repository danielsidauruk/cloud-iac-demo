output "aws_iam_policy_document" {
  value = data.aws_iam_policy_document.ecr_image_pusher.json
}