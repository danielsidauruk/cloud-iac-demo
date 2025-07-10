resource "aws_security_group" "redis" {
  name        = "${var.application_name}-${var.environment_name}-redis-sg"
  description = "Allow Access to Redis instance"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "Security Group for Redis ( ${var.application_name} | ${var.environment_name} )"
    application = var.application_name
    environment = var.environment_name
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}