resource "aws_security_group" "rabbitmq_sg" {
  name_prefix = "${var.application_name}-${var.environment_name}-rabbitmq-sg"
  description = "Allow Access to RabbitMQ instance"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "Security Group for RabbitMQ ( ${var.application_name} | ${var.environment_name} )"
    application = var.application_name
    environment = var.environment_name
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "rabbitmq_ingress_amqps" {
  security_group_id = aws_security_group.rabbitmq_sg.id
  type              = "ingress"
  description       = "RabbitMQ AMQPS (SSL/TLS) protocol"
  from_port         = 5671
  to_port           = 5671
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
}

resource "aws_security_group_rule" "rabbitmq_ingress_ui" {
  security_group_id = aws_security_group.rabbitmq_sg.id
  type              = "ingress"
  description       = "RabbitMQ Management UI (8161)"
  from_port         = 8161
  to_port           = 8161
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
