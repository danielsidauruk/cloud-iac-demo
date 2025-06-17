resource "aws_resourcegroups_group" "main" {
  name = "${var.application_name}-${var.environment_name}"

  resource_query {
    query = jsonencode(
      {
        ResourceTypeFilters = [
          "AWS::AllSupported"
        ]
        TagFilters = [
          {
            Key    = "application"
            Values = [var.application_name]
          },
          {
            Key    = "environment"
            Values = [var.environment_name]
          }
        ]
      }
    )
  }
}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  partition = data.aws_partition.current.partition
}

module "vpc" {
  source = "./modules/vpc"

  application_name = var.application_name
  environment_name = var.environment_name
  primary_region   = var.primary_region
  vpc_cidr_block   = var.vpc_cidr_block
  az_count         = var.az_count
}

module "ecr" {
  source = "./modules/ecr"

  application_name = var.application_name
  environment_name = var.environment_name
  repository_list  = var.repository_list
}

module "eks" {
  source = "./modules/eks"

  application_name                = var.application_name
  environment_name                = var.environment_name
  node_image_type                 = var.node_image_type
  bucket_name                     = var.bucket_name
  kubernetes_namespace            = var.kubernetes_namespace
  node_size                       = var.node_size
  kubernetes_service_account_name = var.kubernetes_service_account_name
  primary_region                  = var.primary_region

  aws_account_id = data.aws_caller_identity.current.account_id

  private_subnet_ids = module.vpc.private_subnet_ids
  rabbitmq_arn       = module.mq.rabbitmq_arn
  vpc_id             = module.vpc.vpc_id

  depends_on = [module.ecr]
}

module "elasticache" {
  source = "./modules/elasticache"

  application_name = var.application_name
  environment_name = var.environment_name
  vpc_cidr_block   = var.vpc_cidr_block
  node_image_type  = var.node_image_type

  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"

  application_name  = var.application_name
  environment_name  = var.environment_name
  admin_users       = var.admin_users
  ecr_image_pushers = var.ecr_image_pushers
  aws_region        = var.primary_region

  aws_account_id = data.aws_caller_identity.current.account_id

  ecr_repositories_arn = module.ecr.ecr_repositories_arn
}

module "mq" {
  source = "./modules/mq"

  application_name = var.application_name
  environment_name = var.environment_name
  username         = var.username

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "rds" {
  source = "./modules/rds"

  application_name = var.application_name
  environment_name = var.environment_name
  username         = var.username
  postgres_dbname  = var.postgres_dbname

  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
}

module "s3" {
  source = "./modules/s3"

  application_name = var.application_name
  environment_name = var.environment_name
  primary_region   = var.primary_region
  bucket_name      = var.bucket_name

  private_route_table_ids = module.vpc.private_route_table_ids
  vpc_id                  = module.vpc.vpc_id
}
