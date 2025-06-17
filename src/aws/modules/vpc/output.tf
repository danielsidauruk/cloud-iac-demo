output "private_subnet_ids" {
  description = "IDs of private subnets."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "private_route_table_ids" {
  description = "IDs of private route tables."
  value       = [for rt in aws_route_table.private : rt.id]
}