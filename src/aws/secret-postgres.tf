resource "random_password" "database_connection_string" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "database_connection_string" {
  name                    = "${var.application_name}-${var.environment_name}-connection-string-test-34"
  description             = "Database connection string"
  recovery_window_in_days = 7

  tags = {
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_secretsmanager_secret_version" "rds_postgres" {
  secret_id     = aws_secretsmanager_secret.database_connection_string.id
  secret_string = random_password.database_connection_string.result
}