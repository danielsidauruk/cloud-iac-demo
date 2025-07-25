output "redis_host_endpoint" {
  description = "Redis ElastiCache endpoint."
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}