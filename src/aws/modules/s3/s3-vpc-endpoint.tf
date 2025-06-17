locals {
  private_route_table_ids = var.private_route_table_ids
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.primary_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = local.private_route_table_ids

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-s3-endpoint"
    application = var.application_name
    environment = var.environment_name
  }
}