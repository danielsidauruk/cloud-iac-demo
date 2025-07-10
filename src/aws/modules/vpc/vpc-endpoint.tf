locals {
  private_route_table_ids = [for rt in aws_route_table.private : rt.id]
  private_subnet_ids      = [for s in aws_subnet.private : s.id]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.primary_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = local.private_route_table_ids

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-s3-endpoint"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.primary_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpc_endpoint.id
  ]

  subnet_ids = local.private_subnet_ids

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-secretsmanager-endpoint"
    application = var.application_name
    environment = var.environment_name
  }
}

# resource "aws_vpc_endpoint" "cloudwatch" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.${var.primary_region}.logs"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   subnet_ids = local.private_subnet_ids

#   tags = {
#     Name        = "${var.application_name}-${var.environment_name}-cloudwatch-endpoint"
#     application = var.application_name
#     environment = var.environment_name
#   }
# }

// i might delete this code

# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.${var.primary_region}.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   subnet_ids = local.private_subnet_ids

#   tags = {
#     Name        = "${var.application_name}-${var.environment_name}-ecr-api-endpoint"
#     application = var.application_name
#     environment = var.environment_name
#   }
# }

# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.${var.primary_region}.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   subnet_ids = local.private_subnet_ids

#   tags = {
#     Name        = "${var.application_name}-${var.environment_name}-ecr-dkr-endpoint"
#     application = var.application_name
#     environment = var.environment_name
#   }
# }