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
      namespace = var.k8s_namespace
    }
    spec = {
      provider = "aws"
      parameters = {
        objects = yamlencode([
          {
            objectName         = "${var.application_name}-${var.environment_name}-connection-string-test-16"
            objectType         = "secretsmanager"
            objectVersionLabel = "AWSCURRENT"
          },
          {
            objectName         = "${var.application_name}-${var.environment_name}-redis-endpoint-test16"
            objectType         = "secretsmanager"
            objectVersionLabel = "AWSCURRENT"
          }
        ])
      }
      secretObjects = [
        {
          secretName = "${var.application_name}-${var.environment_name}-rds-connection-secret"
          type       = "Opaque"
          data = [
            {
              key        = "database_connection_string"
              objectName = "${var.application_name}-${var.environment_name}-connection-string-test-16"
            },
            {
              key        = "Avamys Fluticasone"
              objectName = "awokaowk_test_doang_kok"
            }
          ]
        },
        {
          secretName = "${var.application_name}-${var.environment_name}-redis-endpoint-secret"
          type       = "Opaque"
          data = [
            {
              key        = "redis_endpoint"
              objectName = "${var.application_name}-${var.environment_name}-redis-endpoint-test16"
            }
          ]
        }
      ]
    }
  }
}