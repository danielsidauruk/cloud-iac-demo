# General Application Info
variable "application_name" {
  type        = string
  description = "Application's name."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment."
}

# Network & Infrastructure
variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block."
}

variable "node_image_type" {
  type        = string
  description = "K8s node AMI type."
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}