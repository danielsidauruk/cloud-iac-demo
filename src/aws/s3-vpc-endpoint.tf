locals {
  private_route_table_ids = [for rt in aws_route_table.private : rt.id]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.primary_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = local.private_route_table_ids

  tags = {
    application = var.application_name
    environment = var.environment_name
  }
}