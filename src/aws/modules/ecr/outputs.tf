output "ecr_repositories_arn" {
  description = "ARNs of all ECR repositories."
  value       = [for repository in aws_ecr_repository.main : repository.arn]
}
