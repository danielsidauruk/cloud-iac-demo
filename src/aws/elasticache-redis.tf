resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.application_name}-${var.environment_name}-redis-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.application_name}-${var.environment_name}-redis"
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis.id]

  tags = {
    application = var.application_name
    environment = var.environment_name
  }
}