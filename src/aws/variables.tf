# General Application Info
variable "application_name" {
  type        = string
  description = "The name of the application or project."
}

variable "environment_name" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)."
  default     = "dev"
}

variable "primary_region" {
  type        = string
  description = "The primary AWS region for resource deployment."
}

# Network & Infrastructure
variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block of the VPC where resources will be deployed."
  default     = "10.0.0.0/21"
}

variable "az_count" {
  type        = number
  description = "Number of availability zones to use."
  default     = 3
}

variable "node_image_type" {
  type        = string
  description = "The type of AMI or image used for Kubernetes nodes."
  default     = "AL2_x86_64"
}

variable "node_size" {
  type        = string
  description = "The instance type/size for Kubernetes worker nodes."
  default     = "t3.medium"
}

# Kubernetes Specific
variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace for service accounts."
}

variable "k8s_service_account_name" {
  type        = string
  description = "Kubernetes service account name for workload identity."
}

# Security & Access
variable "admin_users" {
  type        = list(string)
  description = "List of usernames granted admin access."
}

variable "ecr_image_pushers" {
  type        = string
  description = "Identifier or role allowed to push images to ECR."
}

# Application Resources
variable "repository_list" {
  type        = list(string)
  description = "List of container repositories used by the application."
}

variable "username" {
  type        = string
  description = "Default username for infrastructure administration."
}

variable "postgres_dbname" {
  type        = string
  description = "Database name for the PostgreSQL instance."
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for application storage."
}
