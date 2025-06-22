output "postgres_host_endpoint" {
  description = "PostgreSQL database endpoint."
  value       = aws_db_instance.postgres.address
}