resource "kubernetes_config_map" "application_env_config" {
  metadata {
    name      = "${var.application_name}-${var.environment_name}-env-config"
    namespace = kubernetes_namespace.main.metadata[0].name
    labels = {
      app = var.application_name
    }
  }

  data = {
    # Application
    "PORT" = var.application_port

    # Postgres
    "PGUSER"     = var.username
    "PGHOST"     = var.postgres_host_endpoint
    "PGDATABASE" = var.postgres_dbname
    "PGPORT"     = var.postgres_port
    "PGSSLMODE"  = var.pg_ssl_mode

    # RabbitMQ
    "RABBITMQ_SERVER"   = var.rabbitmq_host_endpoint
    "RABBITMQ_USERNAME" = var.username

    # S3 Bucket
    "AWS_REGION"      = var.primary_region
    "AWS_BUCKET_NAME" = var.bucket_name

    # Redis
    "REDIS_SERVER" = var.redis_host_endpoint
    "REDIS_PORT"   = var.redis_port
  }
} 