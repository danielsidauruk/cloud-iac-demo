locals {
  main_application = "${var.application_name}-main"
}

resource "kubernetes_deployment" "main" {
  metadata {
    name      = local.main_application
    namespace = kubernetes_namespace.main.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.main_application
      }
    }

    template {
      metadata {
        labels = {
          app = local.main_application
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
          name  = local.main_application

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
                name = "${var.application_name}-${var.environment_name}-postgresql-secret"
                key  = "postgresql_password"
              }
            }
          }
          env {
            name = "RABBITMQ_PASSWORD"
            value_from {
              secret_key_ref {
                name = "${var.application_name}-${var.environment_name}-rabbitmq-secret"
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
    name      = "${local.main_application}-service"
    namespace = var.kubernetes_namespace

  }
  spec {
    type = "ClusterIP"
    port {
      port        = 3000
      target_port = 3000
    }
    selector = {
      app = local.main_application
    }
  }

  depends_on = [
    kubernetes_deployment.main
  ]
}
