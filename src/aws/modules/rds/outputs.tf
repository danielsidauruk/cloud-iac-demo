output "postgres_host_endpoint" {
  description = "PostgreSQL database endpoint."
  value       = aws_db_instance.postgres.address
}

output "postgresql_secret" {
  value       = aws_secretsmanager_secret.postgresql_secret.name
  description = "PostgreSQL database secret"
}