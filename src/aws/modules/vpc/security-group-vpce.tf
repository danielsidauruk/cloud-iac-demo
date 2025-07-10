resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.application_name}-${var.environment_name}-vpc-endpoint"
  description = "Allow access to VPC Endpoint"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-vpc-endpoint-sg"
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
