resource "helm_release" "csi_secrets_store" {

  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }

}


resource "helm_release" "aws_secrets_provider" {

  name       = "secrets-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

}

resource "kubernetes_manifest" "secret_provider_class" {

  manifest = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind       = "SecretProviderClass"
    metadata = {
      name      = "${var.application_name}-${var.environment_name}-secret-provider-class"
      namespace = kubernetes_namespace.main.metadata[0].name
    }
    spec = {
      provider = "aws"
      parameters = {
        objects = yamlencode([
          {
            objectName         = var.postgresql_secret
            objectType         = "secretsmanager"
            objectVersionLabel = "AWSCURRENT"
          },
          {
            objectName         = var.rabbitmq_secret
            objectType         = "secretsmanager"
            objectVersionLabel = "AWSCURRENT"
          }
        ])
      }
      secretObjects = [
        {
          secretName = "${var.application_name}-${var.environment_name}-postgresql-secret"
          type       = "Opaque"
          data = [
            {
              key        = "postgresql_password"
              objectName = var.postgresql_secret
            }
          ]
        },
        {
          secretName = "${var.application_name}-${var.environment_name}-rabbitmq-secret"
          type       = "Opaque"
          data = [
            {
              key        = "rabbitmq_password"
              objectName = var.rabbitmq_secret
            }
          ]
        }
      ]
    }
  }

  depends_on = [
    helm_release.csi_secrets_store,
    helm_release.aws_secrets_provider
  ]

}