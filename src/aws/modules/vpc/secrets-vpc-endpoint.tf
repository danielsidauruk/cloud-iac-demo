resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.primary_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [for s in aws_subnet.private : s.id]

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-secretsmanager-endpoint"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.primary_region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [for s in aws_subnet.private : s.id]

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-cloudwatch-endpoint"
    application = var.application_name
    environment = var.environment_name
  }
}