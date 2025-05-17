resource "random_password" "database_connection_string" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "database_connection_string" {
  name        = "${var.application_name}-${var.environment_name}-connection-string-test02"
  description = "Database connection string"
}

resource "aws_secretsmanager_secret_version" "rds_postgres" {
  secret_id = aws_secretsmanager_secret.database_connection_string.id

  secret_string = jsonencode({
    host     = aws_db_instance.postgres.address
    port     = 5432
    database = aws_db_instance.postgres.db_name
    username = aws_db_instance.postgres.username
    password = random_password.database_connection_string.result
  })
}