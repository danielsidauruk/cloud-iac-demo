resource "aws_secretsmanager_secret" "redis_endpoint" {
  name        = "${var.application_name}-${var.environment_name}-redis-endpoint-test1"
  description = "Redis Endpoint"
}

resource "aws_secretsmanager_secret_version" "redis_endpoint_value" {
  secret_id = aws_secretsmanager_secret.redis_endpoint.id
  secret_string = jsonencode({
    host = aws_elasticache_cluster.redis.cache_nodes[0].address
    port = 6379
  })
}