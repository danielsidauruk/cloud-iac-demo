resource "random_password" "database_connection_string" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "database_connection_string" {
  name        = "test01-${var.application_name}-${var.environment_name}-connection-string"
  description = "Database connection string"
}

resource "aws_secretsmanager_secret_version" "rds_postgres" {
  secret_id = aws_secretsmanager_secret.database_connection_string.id
  secret_string = jsonencode({
    username = "postgres"
    password = random_password.database_connection_string.result
  })
}
