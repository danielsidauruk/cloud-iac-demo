variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block."
}

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

variable "az_count" {
  type        = number
  description = "Number of Availability Zones."
}