# General Application & Environment
variable "application_name" {
  type        = string
  description = "Application's name."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment."
}

variable "primary_region" {
  type        = string
  description = "Primary AWS region."
}


# Kubernetes Configuration
variable "kubernetes_cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "kubernetes_namespace" {
  type        = string
  description = "Kubernetes namespace."
}

variable "kubernetes_service_account_name" {
  type        = string
  description = "Kubernetes service account name."
}


# IAM Roles
variable "alb_controller_role" {
  type        = string
  description = "ALB Controller IAM role ARN."
}

variable "workload_identity_role" {
  type        = string
  description = "Workload Identity (IRSA) role ARN."
}


# Service Credentials & Endpoints
variable "username" {
  type        = string
  description = "Default admin username."
}

variable "postgres_dbname" {
  type        = string
  description = "PostgreSQL database name."
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name."
}

variable "postgres_host_endpoint" {
  type        = string
  description = "PostgreSQL database endpoint."
}

variable "postgresql_secret" {
  type        = string
  description = "PostgreSQL database secret"
}

variable "rabbitmq_host_endpoint" {
  type        = string
  description = "RabbitMQ broker endpoint."
}

variable "rabbitmq_secret" {
  type        = string
  description = "RabbitMQ broker secret"
}

variable "redis_host_endpoint" {
  type        = string
  description = "Redis ElastiCache endpoint."
}


# Docker Images
variable "main_image" {
  type        = string
  description = "Main's image name"
  default     = ""
}

variable "consumer_image" {
  type        = string
  description = "Consumer's image name"
  default     = ""
}


# Port Numbers & Protocols
variable "application_port" {
  type        = string
  description = "Application service port."
  default     = "3000"
}

variable "redis_port" {
  type        = string
  description = "Redis service port."
  default     = "6379"
}

variable "postgres_port" {
  type        = string
  description = "PostgreSQL service port."
  default     = "5432"
}

variable "pg_ssl_mode" {
  type        = string
  description = "PostgreSQL SSL mode."
  default     = "require"
}
