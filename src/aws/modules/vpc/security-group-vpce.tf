resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.application_name}-${var.environment_name}-vpc-endpoint"
  description = "Allow Access to VPC Endpoint"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "Security Group for VPC Endpoint ( ${var.application_name} | ${var.environment_name} )"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_security_group_rule" "allow_eks_to_vpce" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "Allow EKS to access VPC Endpoint"
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_blocks       = [var.vpc_cidr_block]
}
