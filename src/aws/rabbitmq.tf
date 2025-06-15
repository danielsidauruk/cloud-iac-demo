resource "aws_mq_broker" "rabbitmq_broker" {
  broker_name                = "${var.application_name}-${var.environment_name}-rabbitmq-broker"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  host_instance_type         = "mq.t3.micro"
  deployment_mode            = "SINGLE_INSTANCE"
  security_groups            = [aws_security_group.rabbitmq_sg.id]
  subnet_ids                 = [aws_subnet.private[0].id]
  publicly_accessible        = false
  apply_immediately          = true
  auto_minor_version_upgrade = true

  user {
    username = var.username
    password = random_password.rabbitmq_password.result
  }

  logs {
    general = true
  }

  tags = {
    application = var.application_name
    environment = var.environment_name
  }
}
