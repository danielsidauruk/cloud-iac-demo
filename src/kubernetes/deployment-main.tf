locals {
  application_name = "${var.application_name}-main"
}

resource "kubernetes_deployment" "main" {
  metadata {
    name      = local.application_name
    namespace = kubernetes_namespace.main.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.application_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.application_name
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
          image = var.main_image
          name  = local.application_name

          port {
            container_port = 3000
          }

          volume_mount {
            name       = "secrets-store-inline"
            mount_path = "/mnt/secrets-store"
            read_only  = true
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.application_env_config.metadata[0].name
            }
          }

          env {
            name = "PGPASSWORD"
            value_from {
              secret_key_ref {
                name = "${var.application_name}-${var.environment_name}-rds-connection-secret-test-43"
                key  = "database_password"
              }
            }
          }
          env {
            name = "RABBITMQ_PASSWORD"
            value_from {
              secret_key_ref {
                name = "${var.application_name}-${var.environment_name}-rabbiqmq-password-test-43"
                key  = "rabbitmq_password"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "main" {
  metadata {
    name      = "${local.application_name}-service"
    namespace = var.kubernetes_namespace

  }
  spec {
    type = "ClusterIP"
    port {
      port        = 3000
      target_port = 3000
    }
    selector = {
      app = local.application_name
    }
  }
}
