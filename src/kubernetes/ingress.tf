resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "${var.application_name}-ingress"
    namespace = kubernetes_namespace.main.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.main.metadata[0].name
              port {
                number = 3000
              }
            }
          }
        }
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.main.metadata[0].name
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.ingress_nginx
  ]
}