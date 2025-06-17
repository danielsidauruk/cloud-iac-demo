variable "application_name" {
  type        = string
  description = "Application's name."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment."
}

variable "repository_list" {
  type        = list(string)
  description = "List of container repository names."
}