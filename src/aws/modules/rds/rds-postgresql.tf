resource "aws_db_subnet_group" "rds" {
  name       = "${var.application_name}-${var.environment_name}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.application_name}-${var.environment_name}-postgres"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.postgres_dbname
  username               = var.username
  password               = random_password.postgresql_password.result
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  apply_immediately      = true

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-postgres"
    application = var.application_name
    environment = var.environment_name
  }
}