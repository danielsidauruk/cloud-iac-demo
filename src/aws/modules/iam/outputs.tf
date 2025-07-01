output "administrator_arns_list" {
  value = [
    for administrator in data.aws_iam_user.administrators : administrator.arn
  ]
  description = "List of Administrator ARNs."
}

output "console_access_arn" {
  value       = aws_iam_role.console_access.arn
  description = "ARN of Console Access Role."
}
