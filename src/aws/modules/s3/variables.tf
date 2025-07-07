# General Application Info
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


# Storage
variable "bucket_name" {
  type        = string
  description = "S3 bucket name."
}
