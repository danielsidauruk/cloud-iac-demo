output "kubernetes_cluster_name" {
  value = aws_eks_cluster.main.name
}
output "primary_region" {
  value = var.primary_region
}
output "admin_group_arn" {
  value = aws_iam_group.admin.arn
}
output "alb_controller_role" {
  value = aws_iam_role.alb_controller.arn
}
output "workload_identity_role" {
  value = aws_iam_role.workload_identity.arn
}