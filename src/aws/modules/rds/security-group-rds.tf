resource "aws_security_group" "rds" {
  name        = "${var.application_name}-${var.environment_name}-rds-sg"
  description = "Allow Access to PostgreSQL instance"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "Security Group for PostgreSQL ( ${var.application_name} | ${var.environment_name} )"
    application = var.application_name
    environment = var.environment_name
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
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