# General Application Info
variable "application_name" {
  type        = string
  description = "Application's name."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment."
  default     = "dev"
}


# Network & Infrastructure
variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block."
  default     = "10.0.0.0/21"
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs."
  type        = list(string)
}


# EKS/Kubernetes Specific
variable "node_image_type" {
  type        = string
  description = "K8s node AMI type."
  default     = "AL2_x86_64"
}


# Credentials/Access
variable "username" {
  type        = string
  description = "Admin username."
}