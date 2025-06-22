# General Application Info
variable "application_name" {
  type        = string
  description = "Application's name."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment."
}

# Security & Access
variable "admin_users" {
  type        = list(string)
  description = "List of admin usernames."
}

variable "ecr_image_pushers" {
  type        = string
  description = "Identifier for ECR image pushers."
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID."
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "ecr_repositories_arn" {
  description = "ARNs of ECR repositories."
  type        = list(string)
}