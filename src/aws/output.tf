output "primary_region" {
  value       = var.primary_region
  description = "The primary AWS region."
}

output "kubernetes_cluster_name" {
  value       = module.eks.kubernetes_cluster_name
  description = "Name of the EKS cluster."
}

output "alb_controller_role_arn" {
  value       = module.eks.alb_controller_role_arn
  description = "ARN of the ALB Controller IAM role."
}

output "admin_controller_role" {
  value       = module.eks.admin_controller_role
  description = "ARN of the admin IAM role."
}

output "workload_identity_role" {
  value       = module.eks.workload_identity_role
  description = "ARN of the K8s Workload Identity (IRSA) role."
}

output "postgres_host_endpoint" {
  value       = module.rds.postgres_host_endpoint
  description = "PostgreSQL database endpoint."
}

output "rabbitmq_host_endpoint" {
  value       = module.mq.rabbitmq_host_endpoint
  description = "RabbitMQ broker endpoint."
}

output "redis_host_endpoint" {
  value       = module.elasticache.redis_host_endpoint
  description = "Redis ElastiCache endpoint."
}