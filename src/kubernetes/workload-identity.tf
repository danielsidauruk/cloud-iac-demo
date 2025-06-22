resource "kubernetes_service_account" "workload_identity" {
  metadata {
    name      = var.kubernetes_service_account_name
    namespace = var.kubernetes_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = var.workload_identity_role
    }
  }
}