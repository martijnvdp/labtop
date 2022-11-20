resource "helm_release" "ingress-controller" {
  count = var.kindCluster.config.ingress ? 1 : 0

  provider         = helm
  name             = var.ingressController.name
  chart            = var.ingressController.chart
  create_namespace = true
  namespace        = var.ingressController.namespace
  repository       = var.ingressController.repository
  version          = var.ingressController.version

  values = [var.ingressController.valueFile != "" ? file("${path.module}/templates/ingress_config.yaml") : var.ingressController.valueFile]

  depends_on = [
    kind_cluster.default,
    helm_release.cilium
  ]
}
