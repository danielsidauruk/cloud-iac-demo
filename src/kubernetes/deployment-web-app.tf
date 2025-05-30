
locals {
  web_app_name = "${var.application_name}-app"
}

resource "kubernetes_deployment" "web_app" {
  metadata {
    name      = var.application_name
    namespace = var.k8s_namespace
  }

  spec {
    replicas = 1

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

        container {
          # image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.primary_region}.amazonaws.com/${var.web_app_image.name}:${var.web_app_image.version}"
          image = "nginx"
          name  = var.application_name
          port {
            container_port = 5000
          }
        }
      }
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}

resource "kubernetes_service" "web_app" {
  metadata {
    name      = "${var.application_name}-service"
    namespace = var.k8s_namespace

  }
  spec {
    type = "ClusterIP"
    port {
      port        = 80
      target_port = 5000
    }
    selector = {
      app = var.application_name
    }
  }
}
