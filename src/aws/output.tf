output "kubernetes_cluster_name" {
  value = aws_eks_cluster.main.name
}
output "primary_region" {
  value = var.primary_region
}
output "admin_group_arn" {
  value = aws_iam_group.admin.arn
}
output "alb_controller_role" {
  value = aws_iam_role.alb_controller.arn
}
output "workload_identity_role" {
  value = aws_iam_role.workload_identity.arn
}

output "rabbitmq_broker_mq_host" {
  value = element(aws_mq_broker.rabbitmq_broker.instances[0].endpoints, 0) # Assumes AMQP is the first endpoint
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "rds_postgres_endpoint" {
  value = aws_db_instance.postgres.address
}
