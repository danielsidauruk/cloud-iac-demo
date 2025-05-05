terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }
  backend "s3" {
    bucket  = "openmusicapi-infra-tfstate"
    region  = "ap-southeast-3"
    key     = "openmusicapi-portal-dev"
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.primary_region
}