output "rabbitmq_arn" {
  description = "ARN of the RabbitMQ broker."
  value       = aws_mq_broker.rabbitmq_broker.arn
}

output "rabbitmq_host_endpoint" {
  description = "RabbitMQ broker host endpoint."
  value       = aws_mq_broker.rabbitmq_broker.instances[0].endpoints[0]
}

output "rabbitmq_secret" {
  description = "PostgreSQL broker secret"
  value       = aws_secretsmanager_secret.rabbitmq_secret.name
}