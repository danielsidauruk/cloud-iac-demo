locals {
  cluster_name       = "eks-${var.application_name}-${var.environment_name}"
  cluster_subnet_ids = var.private_subnet_ids
}

resource "aws_eks_cluster" "main" {
  name                      = local.cluster_name
  role_arn                  = aws_iam_role.container_cluster.arn
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {

    security_group_ids = [
      aws_security_group.cluster.id,
      aws_security_group.cluster_nodes.id
    ]

    subnet_ids              = local.cluster_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_controller_policy,
    aws_cloudwatch_log_group.container_cluster
  ]

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-eks-cluster"
    application = var.application_name
    environment = var.environment_name
  }
}
