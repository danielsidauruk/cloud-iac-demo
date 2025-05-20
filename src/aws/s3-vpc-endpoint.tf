# Collect all private route table IDs from your existing setup
locals {
  private_route_table_ids = [for rt in aws_route_table.private : rt.id]
}

# Create a VPC Gateway Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.primary_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = local.private_route_table_ids

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-s3-endpoint"
    Environment = var.environment_name
  }
}