resource "random_password" "postgresql_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "postgresql_secret" {
  name                    = "${var.application_name}-${var.environment_name}-postgresql-password-test-45"
  description             = "Database connection string"
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-postgres-secret"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_secretsmanager_secret_version" "postgresql_password" {
  secret_id     = aws_secretsmanager_secret.postgresql_secret.id
  secret_string = random_password.postgresql_password.result
}
