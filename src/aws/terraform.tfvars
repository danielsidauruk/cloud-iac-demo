# General Application Info
application_name = "app"
environment_name = "dev"
primary_region   = "ap-southeast-1"

# Network & Infrastructure
vpc_cidr_block  = "10.0.0.0/21"
az_count        = 3
node_image_type = "AL2_x86_64"
node_size       = "t3.medium"

# Kubernetes Specific
kubernetes_namespace            = "app"
kubernetes_service_account_name = "app-sa"

# Security & Access
admin_users       = ["developer"]
ecr_image_pushers = "developer"

# Application Resources
repository_list = ["main", "consumer"]
username        = "appadministrator"
postgres_dbname = "appdb"
bucket_name     = "app-dev-bucket"