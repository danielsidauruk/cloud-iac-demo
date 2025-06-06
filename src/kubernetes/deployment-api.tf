resource "kubernetes_deployment" "api" {
  metadata {
    name      = var.application_name
    namespace = var.k8s_namespace
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = var.application_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.application_name
        }
      }

      spec {
        service_account_name = kubernetes_service_account.workload_identity.metadata[0].name

        volume {
          name = "secrets-store-inline"
          csi {
            driver    = "secrets-store.csi.k8s.io"
            read_only = true
            volume_attributes = {
              "secretProviderClass" = kubernetes_manifest.secret_provider_class.manifest.metadata.name
            }
          }
        }

        container {
          # image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.primary_region}.amazonaws.com/${var.web_api_image.name}:${var.web_api_image.version}"
          image = "nginx"
          name  = var.application_name

          port {
            container_port = 80
          }

          volume_mount {
            name       = "secrets-store-inline"
            mount_path = "/mnt/secrets-store"
            read_only  = true
          }

          env {
            name = "DATABASE_CONNECTION_STRING_JSON"
            value_from {
              secret_key_ref {
                name = "${var.application_name}-${var.environment_name}-rds-connection-secret"
                key  = "database_connection_string"
              }
            }
          }
          env {
            name = "REDIS_ENDPOINT_JSON"
            value_from {
              secret_key_ref {
                name = "${var.application_name}-${var.environment_name}-redis-endpoint-secret"
                key  = "redis_endpoint"
              }
            }
          }
        }
      }
    }
  }

  timeouts {
    create = "3m"
    update = "3m"
    delete = "5m"
  }
}

resource "kubernetes_service" "api" {
  metadata {
    name      = "${var.application_name}-service"
    namespace = var.k8s_namespace

  }
  spec {
    type = "ClusterIP"
    port {
      port        = 80
      target_port = 80
    }
    selector = {
      app = var.application_name
    }
  }
}
