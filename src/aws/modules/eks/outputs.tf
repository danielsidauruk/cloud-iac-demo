output "kubernetes_cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.main.name
}

output "alb_controller_role_arn" {
  description = "ARN of the ALB Controller IAM role."
  value       = aws_iam_role.alb_controller.arn
}

output "admin_controller_role" {
  description = "ARN of the admin controller IAM role."
  value       = aws_iam_role.alb_controller.arn
}

output "workload_identity_role" {
  description = "ARN of the Kubernetes Workload Identity role."
  value       = aws_iam_role.workload_identity.arn
}
