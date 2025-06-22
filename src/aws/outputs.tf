# General Application & Environment
output "application_name" {
  value       = var.application_name
  description = "Application's name."
}

output "environment_name" {
  value       = var.environment_name
  description = "Deployment environment."
}

output "primary_region" {
  value       = var.primary_region
  description = "The primary AWS region."
}

# Kubernetes Configuration
output "kubernetes_cluster_name" {
  value       = module.eks.kubernetes_cluster_name
  description = "Name of the EKS cluster."
}

output "kubernetes_namespace" {
  value       = var.kubernetes_namespace
  description = "Kubernetes namespace."
}

output "kubernetes_service_account_name" {
  value       = var.kubernetes_service_account_name
  description = "K8s service account name."
}

# IAM Roles
output "alb_controller_role" {
  value       = module.eks.alb_controller_role_arn
  description = "ALB Controller IAM role ARN."
}

output "workload_identity_role" {
  value       = module.eks.workload_identity_role
  description = "ARN of the K8s Workload Identity (IRSA) role."
}

# Service Credentials & Endpoints
output "bucket_name" {
  value       = var.bucket_name
  description = "S3 bucket name."
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