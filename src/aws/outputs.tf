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
  description = "Primary AWS region."
}

# Kubernetes Configuration
output "kubernetes_cluster_name" {
  value       = module.eks.kubernetes_cluster_name
  description = "EKS cluster name."
}

output "kubernetes_namespace" {
  value       = var.kubernetes_namespace
  description = "Kubernetes namespace."
}

output "kubernetes_service_account_name" {
  value       = var.kubernetes_service_account_name
  description = "Kubernetes service account name."
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

output "console_access_arn" {
  value       = module.iam.console_access_arn
  description = "ARN of Console Access Role."
}

output "administrator_arns_list" {
  value       = module.iam.administrator_arns_list
  description = "List of Administrator ARNs."
}

# Service Credentials & Endpoints
output "username" {
  value       = var.username
  description = "Default admin username."
}

output "postgres_dbname" {
  value       = var.postgres_dbname
  description = "PostgreSQL database name."
}

output "bucket_name" {
  value       = var.bucket_name
  description = "S3 bucket name."
}

output "postgres_host_endpoint" {
  value       = module.rds.postgres_host_endpoint
  description = "PostgreSQL database endpoint."
}

output "postgresql_secret" {
  value       = module.rds.postgresql_secret
  description = "PostgreSQL database secret"
}

output "rabbitmq_host_endpoint" {
  value       = module.mq.rabbitmq_host_endpoint
  description = "RabbitMQ broker endpoint."
}

output "rabbitmq_secret" {
  value       = module.mq.rabbitmq_secret
  description = "RabbitMQ broker secret"
}

output "redis_host_endpoint" {
  value       = module.elasticache.redis_host_endpoint
  description = "Redis ElastiCache endpoint."
}
