resource "aws_db_subnet_group" "rds" {
  name       = "${var.application_name}-${var.environment_name}-rds-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.application_name}-${var.environment_name}-postgres"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.postgres_dbname
  username               = var.postgres_username
  password               = random_password.database_connection_string.result
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  apply_immediately      = true

  tags = {
    application = var.application_name
    environment = var.environment_name
  }
}