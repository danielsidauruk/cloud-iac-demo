locals {
  name = "${var.application_name}-consumer"
}

resource "kubernetes_deployment" "consumer" {
  metadata {
    name      = local.name
    namespace = kubernetes_namespace.main.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.name
      }
    }

    template {
      metadata {
        labels = {
          app = local.name
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
          name  = local.name

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
                name = "${var.application_name}-${var.environment_name}-rabbitmq-password-test-44"
                key  = "rabbitmq_password"
              }
            }
          }
        }
      }
    }
  }
}

