data "aws_iam_policy_document" "console_access" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "eks:*",
      "iam:ListRoles"
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "elasticache:*",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "s3-object-lambda:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "rds:*",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "kms:ListAliases",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:*",
      "logs:*",
      "events:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:*",
      "ecr-public:*"
    ]
    resources = ["*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:*",
      "acm:*",
      "iam:ListServerCertificates",
      "iam:GetServerCertificate",
      "waf-regional:*",
      "wafv2:*",
      "shield:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:*",
      "directconnect:*",
      "vpc-lattice:*",
      "network-firewall:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:CreateServiceLinkedRole",
      "iam:DeleteServiceLinkedRole",
      "iam:GetRole",
      "iam:ListRoles",
      "iam:GetPolicy",
      "iam:ListPolicies",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:PassRole"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "console_access" {
  name        = "${var.application_name}-${var.environment_name}-console-access"
  description = "Allow users to access EKS from the console"
  policy      = data.aws_iam_policy_document.console_access.json
}

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

data "aws_iam_policy_document" "console_access_assume_role_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "console_access" {
  name               = "${var.application_name}-${var.environment_name}-console-access"
  assume_role_policy = data.aws_iam_policy_document.console_access_assume_role_policy.json
}