resource "kubernetes_secret" "datadog" {
  count = local.deployDatadog ? 1 : 0

  metadata {
    name      = var.datadog.secret
    namespace = var.datadog.namespace
  }

  data = {
    "api-key" = var.datadogKeys.api
    "app-key" = var.datadogKeys.app
    "token"   = random_password.clusterToken[0].result
  }

  depends_on = [
    kubernetes_namespace.datadogNamespace
  ]
}

resource "kubernetes_namespace" "datadogNamespace" {
  count = local.deployDatadog ? 1 : 0

  metadata {
    name = var.datadog.namespace
  }

  depends_on = [
    kind_cluster.default,
    helm_release.cilium
  ]
}

resource "random_password" "clusterToken" {
  count = local.deployDatadog ? 1 : 0

  length  = 32
  special = false
}
