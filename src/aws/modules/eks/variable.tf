# General/Context Variables
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

variable "aws_account_id" {
  type        = string
  description = "AWS account ID."
}


# Networking Variables
variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs."
  type        = list(string)
}


# EKS/Kubernetes Variables
variable "node_image_type" {
  type        = string
  description = "K8s node AMI type."
}

variable "node_size" {
  type        = string
  description = "K8s worker node instance type."
}

variable "kubernetes_namespace" {
  type        = string
  description = "K8s namespace for service accounts."
}

variable "kubernetes_service_account_name" {
  type        = string
  description = "K8s service account name for IRSA."
}


# External Service ARNs/References
variable "bucket_name" {
  type        = string
  description = "S3 bucket name."
}

variable "rabbitmq_arn" {
  description = "RabbitMQ broker ARN."
  type        = string
}