data "tls_certificate" "container_cluster_oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "container_cluster_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.container_cluster_oidc.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.container_cluster_oidc.url
}

data "aws_iam_policy_document" "workload_identity_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.container_cluster_oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account_name}"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.container_cluster_oidc.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "workload_identity" {
  name               = "${var.application_name}-${var.environment_name}-workload-identity"
  assume_role_policy = data.aws_iam_policy_document.workload_identity_assume_role_policy.json
}

data "aws_iam_policy_document" "workload_identity_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]

    resources = [
      "arn:aws:secretsmanager:${var.primary_region}:${data.aws_caller_identity.current.account_id}:secret:*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "mq:Connect",
      "mq:Receive",
      "mq:Send"
    ]
    resources = [
      aws_mq_broker.rabbitmq_broker.arn
    ]
  }
}

resource "aws_iam_policy" "workload_identity" {
  name        = "${var.application_name}-${var.environment_name}-workload-identity"
  description = "Policy for ${var.application_name}-${var.environment_name} Workload Identity"
  policy      = data.aws_iam_policy_document.workload_identity_policy.json
}

resource "aws_iam_role_policy_attachment" "workload_identity_policy" {
  role       = aws_iam_role.workload_identity.name
  policy_arn = aws_iam_policy.workload_identity.arn
}
