data "aws_iam_user" "administrators" {
  for_each  = toset(var.admin_users)
  user_name = each.value
}