locals {
  consumer_application = "${var.application_name}-consumer"
}

resource "kubernetes_deployment" "consumer" {
  metadata {
    name      = local.consumer_application
    namespace = kubernetes_namespace.main.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.consumer_application
      }
    }

    template {
      metadata {
        labels = {
          app = local.consumer_application
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
          image = var.consumer_image
          name  = local.consumer_application

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

