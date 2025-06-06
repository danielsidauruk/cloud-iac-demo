resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
    labels = {
      name = "ingress-nginx"
    }
  }
}

resource "helm_release" "ingress_nginx" {

  name       = "ingress"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "nginx-ingress-controller"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.annotations"
    value = "service.beta.kubernetes.io/aws-load-balancer-type: nlb"
  }

}