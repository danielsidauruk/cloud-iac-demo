resource "aws_iam_group" "admin" {
  name = "${var.application_name}-${var.environment_name}-admin"
}

resource "aws_iam_group_membership" "admin" {
  name  = "${var.application_name}-${var.environment_name}-admin"
  users = var.admin_users
  group = aws_iam_group.admin.name
}

resource "aws_iam_group_policy_attachment" "console_access" {
  group      = aws_iam_group.admin.name
  policy_arn = aws_iam_policy.console_access.arn
}

resource "aws_iam_user_policy_attachment" "console_access" {
  for_each   = { for idx, user in var.admin_users : user => user }
  user       = each.key
  policy_arn = aws_iam_policy.console_access.arn
}