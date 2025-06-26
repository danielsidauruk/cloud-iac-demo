resource "random_password" "rabbitmq_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_+[]{}<>?"
}

resource "aws_secretsmanager_secret" "rabbitmq_password" {
  name                    = "${var.application_name}-${var.environment_name}-rabbiqmq-password-test-41"
  description             = "Rabbitmq password"
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-rabbitmq-secret"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_secretsmanager_secret_version" "rabbitmq_password" {
  secret_id     = aws_secretsmanager_secret.rabbitmq_password.id
  secret_string = random_password.rabbitmq_password.result
}